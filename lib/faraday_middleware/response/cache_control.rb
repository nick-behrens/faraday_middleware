
module FaradayMiddleware
  # Internal: Parses a Cache-Control Header and exposes the directives.
  #
  # This is based on 'rack-cache' internals.
  # https://github.com/rtomayko/rack-cache/blob/v1.13.0/lib/rack/cache/cache_control.rb
  # Cache-Control headers are parsed and interpreted according to RFC-7234: https://datatracker.ietf.org/doc/html/rfc7234#section-5.2.2
  class CacheControl < Hash
    def initialize(value)
      parse(value)
    end

    # The "no-store" request directive indicates that a cache MUST NOT store any part of
    # either this request or any response to it. This directive applies to both private
    # and shared caches. "MUST NOT store" in this context means that the cache MUST NOT intentionally
    # store the information in non-volatile storage, and MUST make a best-effort attempt to remove
    # the information from volatile storage as promptly as possible after forwarding it.
    def no_store?
      self['no-store']
    end

    private

    def parse(value)
      return  if value.nil? || value.empty?
      value.delete(' ').split(',').each do |part|
        next if part.empty?
        name, value = part.split('=', 2)
        self[name.downcase] = (value || true) unless name.empty?
      end
      self
    end
  end
end