import {Controller} from "stimulus"
import $ from 'jquery'
import toastr from 'toastr';
import Rails from "@rails/ujs";
import debounce from "../_decorators/debounce"

export default class extends Controller {
    static targets = ["output", "editorWindow", "previewWindow", "previewButton", "saveButton"];

    connect() {
        $(this.editorWindowTarget).on('keydown', this.onEditorChange.bind(this));
        $(this.saveButtonTarget).on('click', this.onSave.bind(this));
        $(this.previewButtonTarget).on('click', this.onPreview.bind(this));
        this._preview();
    }

    onSave(_event) {
        Rails.ajax({
            type: 'patch',
            url: this.data.get('url'),
            data: $.param({text: this.editorWindowTarget.value}),
            success: (_response) => toastr.success("Success"),
            error: (response, status) => toastr.error(response.error, status)
        });
    }

    onPreview(_event) {
        this._preview();
    }

    onEditorChange(event) {
        if (event.metaKey && event.which === 13) this._preview();
    }

    _preview() {
        Rails.ajax({
            type: 'get',
            url: '/editor/preview',
            data: $.param({text: this.editorWindowTarget.value}),
            success: (response) => this.previewWindowTarget.innerHTML = response.result,
            error: (response, status) => toastr.error(response.error, status)
        });
    }
}
