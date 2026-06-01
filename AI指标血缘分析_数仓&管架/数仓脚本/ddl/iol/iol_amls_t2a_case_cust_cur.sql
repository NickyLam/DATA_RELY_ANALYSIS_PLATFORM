/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_case_cust_cur
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_case_cust_cur
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_case_cust_cur purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_case_cust_cur(
    ctrl_cert_invalid_dt date -- 实际控制人证件失效日期
    ,rsrv_04 varchar2(75) -- 备用字段4
    ,oth_hold_cert_type varchar2(192) -- 其他控股股东证件类型
    ,reg_fund_amt number(30,4) -- 注册资本
    ,legal_name varchar2(768) -- 法定代表人名称
    ,addr varchar2(768) -- 地址
    ,reg_fund_curr_cd varchar2(5) -- 注册资本币种
    ,othr_ctct2 varchar2(768) -- 其他联系方式2
    ,bs_valid varchar2(2) -- 可疑验证（参见[字典:aml0042]）
    ,ctrl_cert_no varchar2(192) -- 实际控制人证件号码
    ,hold_cert_type varchar2(9) -- 控股股东证件类型（参见[字典:aml0051]）
    ,bh_valid varchar2(2) -- 大额验证（参见[字典:aml0041]）
    ,due_dt date -- 补录到期日期
    ,tel2 varchar2(96) -- 联系电话2
    ,othr_ctct varchar2(768) -- 其他联系方式
    ,hold_name varchar2(300) -- 控股股东名称
    ,modifier varchar2(48) -- 修改人
    ,ctrl_name varchar2(144) -- 实际控制人名称
    ,cust_id varchar2(48) -- 客户编号
    ,legal_cert_type varchar2(72) -- 法定代表人证件类型（参见[字典:aml0051]）
    ,rsrv_01 varchar2(30) -- 备用字段1
    ,rsrv_02 varchar2(30) -- 备用字段2
    ,cust_name varchar2(768) -- 客户名称
    ,pbc_cust_type varchar2(3) -- pbc客户类型（参见[字典:aml0043]）
    ,creator varchar2(48) -- 创建人
    ,ctrl_cert_type varchar2(57) -- 实际控制人证件类型
    ,ctrl_cert_valid_dt date -- 实际控制人证件生效日期
    ,hold_cert_no varchar2(192) -- 控股股东证件号码
    ,org_id varchar2(24) -- 归属机构编号
    ,pbc_ocp varchar2(48) -- pbc职业分类
    ,cust_type varchar2(2) -- 客户类型（参见[字典:aml0030]）
    ,bs_indus varchar2(48) -- 可疑报告涉及行业分类（参见[字典:aml0044]）
    ,addr2 varchar2(768) -- 地址2
    ,pbc_indus varchar2(48) -- pbc行业分类
    ,oth_cert_type varchar2(192) -- 其他证件类型
    ,oth_ctrl_cert_type varchar2(192) -- 其他实际控制人证件类型
    ,tel varchar2(96) -- 联系电话
    ,oth_legal_cert_type varchar2(192) -- 其他法人证件类型
    ,cert_type varchar2(57) -- 证件类型（参见[字典:aml0050]）
    ,create_tm varchar2(29) -- 创建时间
    ,modify_tm varchar2(29) -- 修改时间
    ,oth_opr_cert_type varchar2(192) -- 对手其他证件类型
    ,cert_no varchar2(192) -- 证件号码
    ,cust_nat varchar2(75) -- 国籍
    ,legal_cert_no varchar2(192) -- 法定代表人证件号码
    ,rsrv_03 varchar2(75) -- 备用字段3
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
grant select on ${iol_schema}.amls_t2a_case_cust_cur to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_case_cust_cur to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_case_cust_cur to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_case_cust_cur to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_case_cust_cur is '案例当前客户信息表';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.ctrl_cert_invalid_dt is '实际控制人证件失效日期';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.oth_hold_cert_type is '其他控股股东证件类型';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.reg_fund_amt is '注册资本';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.legal_name is '法定代表人名称';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.addr is '地址';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.reg_fund_curr_cd is '注册资本币种';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.othr_ctct2 is '其他联系方式2';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.bs_valid is '可疑验证（参见[字典:aml0042]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.ctrl_cert_no is '实际控制人证件号码';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.hold_cert_type is '控股股东证件类型（参见[字典:aml0051]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.bh_valid is '大额验证（参见[字典:aml0041]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.due_dt is '补录到期日期';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.tel2 is '联系电话2';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.othr_ctct is '其他联系方式';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.hold_name is '控股股东名称';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.modifier is '修改人';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.ctrl_name is '实际控制人名称';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.legal_cert_type is '法定代表人证件类型（参见[字典:aml0051]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.rsrv_01 is '备用字段1';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.pbc_cust_type is 'pbc客户类型（参见[字典:aml0043]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.creator is '创建人';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.ctrl_cert_type is '实际控制人证件类型';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.ctrl_cert_valid_dt is '实际控制人证件生效日期';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.hold_cert_no is '控股股东证件号码';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.org_id is '归属机构编号';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.pbc_ocp is 'pbc职业分类';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.cust_type is '客户类型（参见[字典:aml0030]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.bs_indus is '可疑报告涉及行业分类（参见[字典:aml0044]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.addr2 is '地址2';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.pbc_indus is 'pbc行业分类';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.oth_cert_type is '其他证件类型';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.oth_ctrl_cert_type is '其他实际控制人证件类型';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.tel is '联系电话';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.oth_legal_cert_type is '其他法人证件类型';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.cert_type is '证件类型（参见[字典:aml0050]）';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.oth_opr_cert_type is '对手其他证件类型';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.cert_no is '证件号码';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.cust_nat is '国籍';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.legal_cert_no is '法定代表人证件号码';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t2a_case_cust_cur.etl_timestamp is 'ETL处理时间戳';
