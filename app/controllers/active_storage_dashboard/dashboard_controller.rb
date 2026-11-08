# frozen_string_literal: true

module ActiveStorageDashboard
  class DashboardController < ApplicationController
    STATS = {
      "attachments" => -> { ActiveStorage::Attachment.count },
      "blobs" => -> { ActiveStorage::Blob.count },
      "purgable_blobs" => -> {
        ActiveStorage::Blob
          .left_outer_joins(:attachments)
          .where(active_storage_attachments: {id: nil})
          .count
      },
      "total_storage" => -> { ActiveStorage::Blob.sum(:byte_size) },
      "variant_records" => -> { defined?(ActiveStorage::VariantRecord) ? ActiveStorage::VariantRecord.count : 0 },
    }.freeze

    layout false, except: :index

    def index
      @recent_blobs = ActiveStorage::Blob.order(created_at: :desc).limit(5)
    end

    def stat
      @stat = params[:stat]
      return head(:not_found) unless STATS.key?(@stat)

      @value = STATS[@stat].call
    end

    def content_types
      @content_types = ActiveStorage::Blob.group(:content_type).count.sort_by { |_, count| -count }.first(5)
    end

    def storage_usage
      @blobs_count = ActiveStorage::Blob.count
      @total_storage = ActiveStorage::Blob.sum(:byte_size)
      @largest_blob = ActiveStorage::Blob.order(byte_size: :desc).first
    end
  end
end
