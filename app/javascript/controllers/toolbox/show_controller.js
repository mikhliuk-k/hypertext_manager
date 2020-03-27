import {Controller} from "stimulus"
import $ from 'jquery'
import toastr from 'toastr';
import Rails from "@rails/ujs";

export default class extends Controller {
    static targets = ["sourceEntity", "destEntity", "find", "resultList"];

    onFindClick(event) {
        Rails.ajax({
            type: 'post',
            url: '/toolbox/find',
            data: $.param({source_entity: this.sourceEntityTarget.value, dest_entity: this.destEntityTarget.value}),
            success: (response) => this.resultListTarget.innerHTML = response.body.innerHTML,
            error: (response, status) => toastr.error(response.error, status)
        })
    }
}
