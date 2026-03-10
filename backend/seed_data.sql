
-- Seed data for Remediation and Treatment Steps
-- This script populates the database with advice for various crop diseases.

-- Clear existing data to avoid duplicates
TRUNCATE public.treatment_steps RESTART IDENTITY CASCADE;
TRUNCATE public.remediation CASCADE;

-- 15: Potato Early Blight
INSERT INTO public.remediation (disease_id, disease_name, general_advice) VALUES 
('15', 'Potato Early Blight', 'Practice crop rotation and remove infected debris after harvest.');

INSERT INTO public.treatment_steps (disease_id, step_number, title, description, type, safety_level, dosage, timing) VALUES
('15', 1, 'Apply Chlorothalonil', 'Spray Chlorothalonil fungicide at first sign of disease.', 'chemical', 'warning', '2.0 g/L', 'Early morning'),
('15', 2, 'Copper Spray', 'Use copper-based sprays for organic control.', 'organic', 'safe', '3.0 g/L', 'Weekly');

-- 16: Potato Late Blight
INSERT INTO public.remediation (disease_id, disease_name, general_advice) VALUES 
('16', 'Potato Late Blight', 'Destroy cull piles and use certified disease-free tubers.');

INSERT INTO public.treatment_steps (disease_id, step_number, title, description, type, safety_level, dosage, timing) VALUES
('16', 1, 'Mancozeb Application', 'Apply Mancozeb preventively during humid weather.', 'chemical', 'warning', '2.5 g/L', 'Before rain'),
('16', 2, 'Bacillus subtilis', 'Use bio-fungicides to suppress pathogen growth.', 'organic', 'safe', '10 ml/L', 'Bi-weekly');

-- 20: Tomato Early Blight
INSERT INTO public.remediation (disease_id, disease_name, general_advice) VALUES 
('20', 'Tomato Early Blight', 'Mulch the soil and avoid overhead watering to reduce splash-back.');

INSERT INTO public.treatment_steps (disease_id, step_number, title, description, type, safety_level, dosage, timing) VALUES
('20', 1, 'Pruning', 'Remove lower leaves to improve air circulation.', 'cultural', 'safe', NULL, 'Ongoing');

-- 21: Tomato Late Blight
INSERT INTO public.remediation (disease_id, disease_name, general_advice) VALUES 
('21', 'Tomato Late Blight', 'Immediate removal of infected plants is critical.');

INSERT INTO public.treatment_steps (disease_id, step_number, title, description, type, safety_level, dosage, timing) VALUES
('21', 1, 'Metalaxyl Spray', 'Use Metalaxyl-M for systemic control in severe cases.', 'chemical', 'warning', '1.5 g/L', 'Immediately');

-- Provide generic help for other classes
INSERT INTO public.remediation (disease_id, disease_name, general_advice)
SELECT i::text, name, 'Maintain good hygiene and monitor for changes.'
FROM (VALUES 
('0', 'Apple Black Rot'), ('1', 'Apple Cedar Rust'), ('2', 'Apple Scab'), ('3', 'Apple Healthy'),
('4', 'Bacterial Leaf Spot'), ('5', 'Bacterial leaf blight'), ('6', 'Brown spot'), ('7', 'Corn Gray Leaf Spot'),
('8', 'Corn Common Rust'), ('9', 'Corn Northern Leaf Blight'), ('10', 'Corn Healthy'), ('11', 'Healthy'),
('12', 'Leaf smut'), ('13', 'Pepper Bell Bacterial Spot'), ('14', 'Pepper Bell Healthy'), ('17', 'Potato Healthy'),
('18', 'Powdery Mildew'), ('19', 'Mosaic Disease'), ('22', 'Tomato Leaf Mold'), ('23', 'Tomato Septoria Leaf Spot'),
('24', 'Tomato Spider Mites'), ('25', 'Tomato Target Spot'), ('26', 'Tomato Yellow Leaf Curl Virus'),
('27', 'Septoria'), ('28', 'Stripe Rust')
) AS t(i, name);

INSERT INTO public.treatment_steps (disease_id, step_number, title, description, type, safety_level)
SELECT i::text, 1, 'Monitor Progress', 'Check back in 2-3 days for any changes in leaf health.', 'cultural', 'safe'
FROM (VALUES 
('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9'), ('10'), ('11'), ('12'), ('13'), ('14'), ('17'), ('18'), ('19'), ('22'), ('23'), ('24'), ('25'), ('26'), ('27'), ('28')
) AS t(i);
