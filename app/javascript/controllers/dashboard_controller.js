import { Controller } from "@hotwired/stimulus"

export default class DashboardController extends Controller {
  static targets = [
    "form", "name", "category", "price", "vegetarian", "image",
    "clearButton", "tableBody", "submitButton"
  ]

  connect() {
    this.editingItemId = null;
  }

  async handleFormSubmit(e) {
    e.preventDefault();

    const formData = new FormData();
    formData.append("food_item[name]", this.nameTarget.value);
    formData.append("food_item[category]", this.categoryTarget.value);
    formData.append("food_item[price]", this.priceTarget.value);
    formData.append("food_item[vegetarian]", this.vegetarianTarget.checked);
    if (this.imageTarget.files[0]) {
      formData.append("food_item[image]", this.imageTarget.files[0]);
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    if (csrfToken) {
      formData.append("authenticity_token", csrfToken);
    }

    let url = "/food_items";
    let method = "POST";
    if (this.editingItemId) {
      url = `/food_items/${this.editingItemId}`;
      method = "PATCH";
    }

    const headers = {
      'X-CSRF-Token': csrfToken
    };

    try {
      const resp = await fetch(url, {
        method,
        body: formData,
        headers,
        credentials: "same-origin"
      });

      if (!resp.ok) {
        const errorData = await resp.json();
        throw errorData;
      }

      const item = await resp.json();

      window.location.reload();
    } catch (err) {
      console.error("Save failed:", err);
      alert("Could not save food item: " + (err.errors || JSON.stringify(err)));
    }
  }

  handleEditItem(e) {
    const id = parseInt(e.target.dataset.id);
    const row = e.target.closest('tr');

    const cells = row.querySelectorAll('td');
    const name = cells[1].textContent;
    const category = cells[2].textContent;
    const price = parseFloat(cells[3].textContent.replace('$', ''));
    const vegetarian = cells[4].textContent === 'Yes';

    this.editingItemId = id;
    this.nameTarget.value = name;
    this.categoryTarget.value = category;
    this.priceTarget.value = price;
    this.vegetarianTarget.checked = vegetarian;
    this.submitButtonTarget.textContent = 'Update Item';
    this.formTarget.scrollIntoView({ behavior: 'smooth' });
  }

  async handleDeleteItem(e) {
    const id = parseInt(e.target.dataset.id);
    if (!confirm("Are you sure?")) return;

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    try {
      let resp = await fetch(`/food_items/${id}`, {
        method: "DELETE",
        headers: {
          'X-CSRF-Token': csrfToken,
          'Content-Type': 'application/json'
        },
        credentials: "same-origin"
      });
      if (!resp.ok) throw await resp.text();

      window.location.reload();
    } catch (e) {
      console.error("Delete failed:", e);
      alert("Could not delete item");
    }
  }

  clearForm() {
    this.formTarget.reset();
    this.editingItemId = null;
    this.submitButtonTarget.textContent = 'Add Item';
  }
}
