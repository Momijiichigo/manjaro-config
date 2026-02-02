
        providers = {

          localai = {
            prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
            prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

            get_url = function() return "http://localhost:8080/v1/chat/completions" end,

            get_headers = function()
              -- local api_key = assert(os.getenv("OPENAI_API_KEY"), "OPENAI_API_KEY env var not set")
              return {
                -- Authorization = "Bearer " .. api_key,
                ["Content-Type"] = "application/json",
              }
            end,

            get_models = function(headers)
              local response, err = require("CopilotChat.utils").curl_get("http://localhost:8080/v1/models", {
                headers = headers,
                json_response = true,
              })
              if err then error(err) end
              return vim
              .iter(response.body.data)
              :filter(function(model)
                local exclude_patterns = {
                  "audio",
                  "babbage",
                  "dall%-e",
                  "davinci",
                  "embedding",
                  "image",
                  "moderation",
                  "realtime",
                  "transcribe",
                  "tts",
                  "whisper",
                }
                for _, pattern in ipairs(exclude_patterns) do
                  if model.id:match(pattern) then return false end
                end
                return true
              end)
              :map(
                function(model)
                  return {
                    id = model.id,
                    name = model.id,
                  }
                end
              )
              :totable()
            end,

            -- embed = 'copilot_embeddings',
            embed = function(inputs, headers)
              local response, err =
              require("CopilotChat.utils").curl_post("http://localhost:8080/v1/embeddings", {
                headers = headers,
                json_request = true,
                json_response = true,
                body = {
                  model = "all-MiniLM-L6-v2",
                  input = inputs,
                },
              })
              if err then error(err) end
              return response.body.data
            end,
          },
        }
