package com.afunms.config.model;

import com.afunms.common.base.BaseVo;

public class Knowledge extends BaseVo {

	private int id;
	private String category;
	private String entity;
	private String subentity;
	private String attachfiles;
	private String bak;

	public String getAttachfiles() {
		return attachfiles;
	}

	public String getBak() {
		return bak;
	}

	public String getCategory() {
		return category;
	}

	public String getEntity() {
		return entity;
	}

	public int getId() {
		return id;
	}

	public String getSubentity() {
		return subentity;
	}

	public void setAttachfiles(String attachfiles) {
		this.attachfiles = attachfiles;
	}

	public void setBak(String bak) {
		this.bak = bak;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public void setEntity(String entity) {
		this.entity = entity;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setSubentity(String subentity) {
		this.subentity = subentity;
	}

}
