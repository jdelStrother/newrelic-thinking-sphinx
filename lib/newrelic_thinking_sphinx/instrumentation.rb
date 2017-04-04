DependencyDetection.defer do
  @name = :thinking_sphinx

  depends_on do
    defined?(::ThinkingSphinx) and !NewRelic::Control.instance['disable_thinking_sphinx']
  end

  executes do
    NewRelic::Agent.logger.info 'Installing Thinking Sphinx instrumentation'
  end

  executes do
    class ::ThinkingSphinx::Search
      include NewRelic::Agent::MethodTracer

      add_method_tracer :populate
    end

    class ::ThinkingSphinx::BatchedSearch
      include NewRelic::Agent::MethodTracer

      add_method_tracer :populate
    end

    # #query will show us actual sphinx time vs #populate which includes db fetching
    class ::ThinkingSphinx::Connection::Client
      include NewRelic::Agent::MethodTracer

      add_method_tracer :query
    end
  end
end
