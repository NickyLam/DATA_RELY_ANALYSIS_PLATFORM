/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_ifc_fodderloan_erpfiledt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt(
    ife_transdate varchar2(24) -- 数据日期
    ,ife_filename varchar2(150) -- 文件名
    ,ife_company varchar2(600) -- 公司
    ,ife_userareatype varchar2(60) -- 客户区域分类
    ,ife_username varchar2(150) -- 客户名称
    ,ife_idtype varchar2(30) -- 客户证件类型
    ,ife_idno varchar2(54) -- 客户证件号码
    ,ife_department varchar2(150) -- 部门名称
    ,ife_province varchar2(60) -- 省
    ,ife_city varchar2(60) -- 市
    ,ife_area varchar2(60) -- 区
    ,ife_address varchar2(600) -- 详细地址
    ,ife_salesman varchar2(150) -- 业务员名称
    ,ife_is17 varchar2(30) -- is17
    ,ife_date varchar2(60) -- 单据日期
    ,ife_stockcode varchar2(90) -- 存货编码
    ,ife_productname varchar2(300) -- 产品名称
    ,ife_stocktype varchar2(180) -- 存货分类
    ,ife_materialtype varchar2(180) -- 物料大类
    ,ife_brand varchar2(180) -- 品牌
    ,ife_particlesize varchar2(150) -- 粒径
    ,ife_specifications varchar2(150) -- 规格
    ,ife_tonnage varchar2(150) -- 吨数
    ,ife_packagenumber varchar2(150) -- 包数
    ,ife_unitprice varchar2(60) -- 单价
    ,ife_salesvolume varchar2(60) -- 销售额
    ,exter_bat_seq varchar2(64) -- 外围批次流水(推送成功-不为空；推送失败或未推送-为空)
    ,push_type_flag varchar2(64) -- 推送状态标识(未推送为空)
    ,ife_merchantid varchar2(30) -- 商户号（恒兴-空  粤海-yhdfd）
    ,ife_pca varchar2(120) -- 省市区
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt to ${iml_schema};
grant select on ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt to ${icl_schema};
grant select on ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt to ${idl_schema};
grant select on ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt is '粤海恒兴ERP商户数据';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_transdate is '数据日期';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_filename is '文件名';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_company is '公司';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_userareatype is '客户区域分类';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_username is '客户名称';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_idtype is '客户证件类型';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_idno is '客户证件号码';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_department is '部门名称';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_province is '省';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_city is '市';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_area is '区';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_address is '详细地址';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_salesman is '业务员名称';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_is17 is 'is17';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_date is '单据日期';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_stockcode is '存货编码';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_productname is '产品名称';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_stocktype is '存货分类';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_materialtype is '物料大类';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_brand is '品牌';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_particlesize is '粒径';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_specifications is '规格';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_tonnage is '吨数';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_packagenumber is '包数';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_unitprice is '单价';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_salesvolume is '销售额';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.exter_bat_seq is '外围批次流水(推送成功-不为空；推送失败或未推送-为空)';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.push_type_flag is '推送状态标识(未推送为空)';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_merchantid is '商户号（恒兴-空  粤海-yhdfd）';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.ife_pca is '省市区';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_ifc_fodderloan_erpfiledt.etl_timestamp is 'ETL处理时间戳';
