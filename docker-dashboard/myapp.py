import streamlit as st
import docker

# Connect to Docker Engine
client = docker.from_env()

st.set_page_config(page_title="Docker Dashboard", page_icon="🐳", layout="wide")

st.title("🐳 Docker Dashboard")
st.write("Monitor Docker Containers, Images, Networks and Volumes")

# Refresh Button
if st.button("🔄 Refresh"):
    st.rerun()

# -----------------------
# Containers
# -----------------------
st.header("📦 Containers")

containers = client.containers.list(all=True)

if containers:
    data = []
    for c in containers:
        ports = ""
        if c.attrs["NetworkSettings"]["Ports"]:
            ports = str(c.attrs["NetworkSettings"]["Ports"])
        
        data.append({
            "Name": c.name,
            "Image": c.image.tags[0] if c.image.tags else "None",
            "Status": c.status,
            "Container ID": c.short_id,
            "Ports": ports
        })
    st.dataframe(data, use_container_width=True)
else:
    st.info("No Containers Found")

# -----------------------
# Images (Added missing section)
# -----------------------
st.header("🖼️ Images")

images = client.images.list()

if images:
    img_data = []
    for img in images:
        img_data.append({
            "ID": img.short_id,
            "Tags": ", ".join(img.tags) if img.tags else "None",
            "Size (MB)": round(img.attrs["Size"] / (1024 * 1024), 2)
        })
    st.dataframe(img_data, use_container_width=True)
else:
    st.info("No Images Found")

# -----------------------
# Networks (Added missing section)
# -----------------------
st.header("🌐 Networks")

networks = client.networks.list()

if networks:
    net_data = []
    for net in networks:
        net_data.append({
            "Name": net.name,
            "ID": net.short_id,
            "Driver": net.attrs["Driver"]
        })
    st.dataframe(net_data, use_container_width=True)
else:
    st.info("No Networks Found")

# -----------------------
# Volumes
# -----------------------
st.header("💾 Volumes")

volumes = client.volumes.list()

if volumes:
    vol_data = []
    for vol in volumes:
        vol_data.append({
            "Volume": vol.name,
            "Mountpoint": vol.attrs["Mountpoint"]
        })
    st.dataframe(vol_data, use_container_width=True)
else:
    st.info("No Volumes Found")

# -----------------------
# System Information
# -----------------------
st.header("⚙️ Docker Information")

info = client.info()

col1, col2, col3 = st.columns(3)

col1.metric("Containers", info["Containers"])
col2.metric("Running", info["ContainersRunning"])
col3.metric("Images", info["Images"])

col1.metric("CPUs", info["NCPU"])
col2.metric("Memory (GB)", round(info["MemTotal"]/(1024**3),2))
col3.metric("Docker Version", client.version()["Version"])

st.success("Dashboard Loaded Successfully 🚀")
