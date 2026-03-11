import torch
import torch.nn as nn
from torchvision import models
from app.services.labels import CLASS_NAMES

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

num_classes = 15

# 🔥 Load MobileNetV2 (same as training)
model = models.mobilenet_v2(weights=None)
model.classifier[1] = nn.Linear(model.last_channel, num_classes)

model.load_state_dict(torch.load("app/model/plant_model.pth", map_location=device))
model = model.to(device)
model.eval()