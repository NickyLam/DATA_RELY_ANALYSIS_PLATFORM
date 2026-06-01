create table mc_orga_para_jxkh
(
  org_no        VARCHAR2(30),
  org_name      VARCHAR2(200),
  super_org_id  VARCHAR2(30),
  org_level     VARCHAR2(30),
  org_area      VARCHAR2(30),
  org_level_bu  VARCHAR2(30),
  remark        VARCHAR2(200),
  etl_dt        DATE,
  etl_timestamp TIMESTAMP(6)
)
compress
nologging;
comment on table mc_orga_para_jxkh
  is '绩效考核机构表';
comment on column mc_orga_para_jxkh.org_no
  is '机构编码';
comment on column mc_orga_para_jxkh.org_name
  is '机构名称';
comment on column mc_orga_para_jxkh.super_org_id
  is '上级机构编码';
comment on column mc_orga_para_jxkh.org_level
  is '组织级别';
comment on column mc_orga_para_jxkh.org_area
  is '地区分类';
comment on column mc_orga_para_jxkh.org_level_bu
  is '组织业务级别';
comment on column mc_orga_para_jxkh.remark
  is '备注';
comment on column mc_orga_para_jxkh.etl_dt
  is 'ETL处理日期';
comment on column mc_orga_para_jxkh.etl_timestamp
  is 'ETL处理时间戳';


