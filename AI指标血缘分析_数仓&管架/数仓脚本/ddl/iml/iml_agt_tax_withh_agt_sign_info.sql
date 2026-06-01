/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_tax_withh_agt_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_tax_withh_agt_sign_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_tax_withh_agt_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tax_withh_agt_sign_info(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_dt date -- 签约日期
    ,sign_flow_num varchar2(100) -- 签约流水号
    ,sign_tm timestamp -- 签约时间
    ,sign_agt_id varchar2(60) -- 签约协议编号
    ,taxpayer_id varchar2(60) -- 纳税人编号
    ,org_cate_cd varchar2(30) -- 机关类别代码
    ,impose_org_id varchar2(60) -- 征收机关编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,withh_acct_id varchar2(60) -- 扣缴账户编号
    ,acct_name varchar2(375) -- 账户名称
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(20) -- 证件号码
    ,sign_org_id varchar2(60) -- 签约机构编号
    ,oper_teller_id varchar2(60) -- 操作柜员编号
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,matn_org_id varchar2(60) -- 维护机构编号
    ,matn_teller_id varchar2(60) -- 维护柜员编号
    ,matn_auth_teller_id varchar2(60) -- 维护授权柜员编号
    ,matn_dt date -- 维护日期
    ,matn_tm timestamp -- 维护时间
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,remark varchar2(750) -- 备注
    ,prov_city_ets_idf_cd varchar2(30) -- 省市ETS标识代码
    ,impose_org_name varchar2(375) -- 征收机关名称
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_tax_withh_agt_sign_info to ${icl_schema};
grant select on ${iml_schema}.agt_tax_withh_agt_sign_info to ${idl_schema};
grant select on ${iml_schema}.agt_tax_withh_agt_sign_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_tax_withh_agt_sign_info is '财税扣缴协议签约信息';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.sign_flow_num is '签约流水号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.sign_tm is '签约时间';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.sign_agt_id is '签约协议编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.taxpayer_id is '纳税人编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.org_cate_cd is '机关类别代码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.impose_org_id is '征收机关编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.withh_acct_id is '扣缴账户编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.acct_name is '账户名称';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.cert_no is '证件号码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.matn_org_id is '维护机构编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.matn_teller_id is '维护柜员编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.matn_auth_teller_id is '维护授权柜员编号';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.matn_dt is '维护日期';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.matn_tm is '维护时间';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.remark is '备注';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.prov_city_ets_idf_cd is '省市ETS标识代码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.impose_org_name is '征收机关名称';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_tax_withh_agt_sign_info.etl_timestamp is 'ETL处理时间戳';
