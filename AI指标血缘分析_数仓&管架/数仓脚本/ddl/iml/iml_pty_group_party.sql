/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_group_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_group_party
whenever sqlerror continue none;
drop table ${iml_schema}.pty_group_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_group_party(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,group_name varchar2(500) -- 集团名称
    ,group_abbr varchar2(500) -- 集团简称
    ,group_en_name varchar2(500) -- 集团英文名称
    ,cty_rg_cd varchar2(30) -- 国家和地区代码
    ,work_land_dist_cd varchar2(30) -- 办公地行政区划代码
    ,dom_work_addr varchar2(500) -- 国内办公地址
    ,ibank_group_flg varchar2(30) -- 同业集团标志
    ,mem_cnt number(22,0) -- 集团成员数
    ,group_risk_warn_sgn_cd varchar2(30) -- 集团风险预警信号代码
    ,group_status_cd varchar2(30) -- 集团状态代码
    ,parent_corp_cust_id varchar2(100) -- 母公司客户编号
    ,cust_mgr_name varchar2(500) -- 客户经理姓名
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,tax_resdnt_idti_cd varchar2(10) -- 税收居民身份代码
    ,tax_org_cate_cd varchar2(30) -- 税收机构类别代码
    ,group_cust_type_cd varchar2(10) -- 集团客户类型代码
    ,bk_idtfy_group_cust_flg varchar2(10) -- 认定集团客户机构类型代码
    ,actl_ctrler_name varchar2(500) -- 实际控制人名称
    ,actl_ctrler_cert_no varchar2(100) -- 实际控制人证件号码
    ,actl_ctrler_cert_type_cd varchar2(30) -- 实际控制人证件类型代码
    ,actl_ctrler_cty_cd varchar2(30) -- 实际控制人国家代码
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
grant select on ${iml_schema}.pty_group_party to ${icl_schema};
grant select on ${iml_schema}.pty_group_party to ${idl_schema};
grant select on ${iml_schema}.pty_group_party to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_group_party is '集团当事人';
comment on column ${iml_schema}.pty_group_party.party_id is '当事人编号';
comment on column ${iml_schema}.pty_group_party.lp_id is '法人编号';
comment on column ${iml_schema}.pty_group_party.group_name is '集团名称';
comment on column ${iml_schema}.pty_group_party.group_abbr is '集团简称';
comment on column ${iml_schema}.pty_group_party.group_en_name is '集团英文名称';
comment on column ${iml_schema}.pty_group_party.cty_rg_cd is '国家和地区代码';
comment on column ${iml_schema}.pty_group_party.work_land_dist_cd is '办公地行政区划代码';
comment on column ${iml_schema}.pty_group_party.dom_work_addr is '国内办公地址';
comment on column ${iml_schema}.pty_group_party.ibank_group_flg is '同业集团标志';
comment on column ${iml_schema}.pty_group_party.mem_cnt is '集团成员数';
comment on column ${iml_schema}.pty_group_party.group_risk_warn_sgn_cd is '集团风险预警信号代码';
comment on column ${iml_schema}.pty_group_party.group_status_cd is '集团状态代码';
comment on column ${iml_schema}.pty_group_party.parent_corp_cust_id is '母公司客户编号';
comment on column ${iml_schema}.pty_group_party.cust_mgr_name is '客户经理姓名';
comment on column ${iml_schema}.pty_group_party.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.pty_group_party.tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${iml_schema}.pty_group_party.tax_org_cate_cd is '税收机构类别代码';
comment on column ${iml_schema}.pty_group_party.group_cust_type_cd is '集团客户类型代码';
comment on column ${iml_schema}.pty_group_party.bk_idtfy_group_cust_flg is '认定集团客户机构类型代码';
comment on column ${iml_schema}.pty_group_party.actl_ctrler_name is '实际控制人名称';
comment on column ${iml_schema}.pty_group_party.actl_ctrler_cert_no is '实际控制人证件号码';
comment on column ${iml_schema}.pty_group_party.actl_ctrler_cert_type_cd is '实际控制人证件类型代码';
comment on column ${iml_schema}.pty_group_party.actl_ctrler_cty_cd is '实际控制人国家代码';
comment on column ${iml_schema}.pty_group_party.create_dt is '创建日期';
comment on column ${iml_schema}.pty_group_party.update_dt is '更新日期';
comment on column ${iml_schema}.pty_group_party.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_group_party.id_mark is '增删标志';
comment on column ${iml_schema}.pty_group_party.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_group_party.job_cd is '任务编码';
comment on column ${iml_schema}.pty_group_party.etl_timestamp is 'ETL处理时间戳';
