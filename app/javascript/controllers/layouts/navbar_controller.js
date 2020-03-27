import {Controller} from "stimulus"
import $ from 'jquery'
import toastr from 'toastr';
import Rails from "@rails/ujs";

export default class extends Controller {
    static targets = ["search"];

    onSearchKeyUp(event) {
        if (event.which !== 13 || this.searchTarget.value.length === 0) return;

        Rails.ajax({
            type: 'get',
            url: `/search/check?query=${encodeURIComponent(this.searchTarget.value)}`,
            success: (_response) => window.location.href = `/search?query=${encodeURIComponent(this.searchTarget.value)}`,
            error: (response, status) => toastr.error(response.error, status)
        });
    }

}
