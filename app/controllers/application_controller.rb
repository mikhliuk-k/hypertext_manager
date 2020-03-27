class ApplicationController < ActionController::Base

  rescue_from StandardError, with: :render_ajax_error_with_trace
  rescue_from RuntimeError, with: :render_ajax_error

  private

  def render_ajax_ok
    render json: { success: 'OK' }.to_json, status: :ok
  end

  def render_ajax_error(e)
    render json: {error: "#{e}"}, status: :internal_server_error, content_type: 'application/json'
  end

  def render_ajax_error_with_trace(e)
    render json: {error: "#{e} #{e.backtrace[0..7].join("\n")}"}, status: :internal_server_error, content_type: 'application/json'
  end

end
