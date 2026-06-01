/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_finc_prod_clear_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_finc_prod_clear_acct_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_finc_prod_clear_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_prod_clear_acct_info(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(750) -- 产品名称
    ,ta_cd varchar2(30) -- TA代码
    ,buy_acct_id varchar2(100) -- 购买账户编号
    ,redem_acct_id varchar2(100) -- 赎回账户编号
    ,realred_acct_id varchar2(100) -- 实时赎回垫资账户编号
    ,rgst_rgst_acct_bank_id varchar2(60) -- 注册登记账户银行编号
    ,coll_cap_vrfction_acct_id varchar2(60) -- 募集验资账户编号
    ,coll_cap_veri_acct_acct_name varchar2(375) -- 募集验资户账户名称
    ,cap_vrfction_acct_bank_id varchar2(60) -- 验资账户银行编号
    ,make_acct_bank_acct_id varchar2(60) -- 上帐银行账户编号
    ,make_acct_bank_acct_num_name varchar2(375) -- 上帐银行账号名称
    ,keep_acct_bank_acct_id varchar2(60) -- 下帐银行账户编号
    ,keep_acct_bank_acct_num_name varchar2(375) -- 下帐银行账号名称
    ,stl_way_cd varchar2(10) -- 结算方式代码
    ,trust_org_open_bank_name varchar2(500) -- 托管机构开户行名称
    ,trust_org_name varchar2(375) -- 托管机构名称
    ,remark_1 varchar2(750) -- 备注1
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_finc_prod_clear_acct_info to ${icl_schema};
grant select on ${iml_schema}.agt_finc_prod_clear_acct_info to ${idl_schema};
grant select on ${iml_schema}.agt_finc_prod_clear_acct_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_finc_prod_clear_acct_info is '理财产品清算账户信息';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.prod_id is '产品编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.prod_name is '产品名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.buy_acct_id is '购买账户编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.redem_acct_id is '赎回账户编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.realred_acct_id is '实时赎回垫资账户编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.rgst_rgst_acct_bank_id is '注册登记账户银行编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.coll_cap_vrfction_acct_id is '募集验资账户编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.coll_cap_veri_acct_acct_name is '募集验资户账户名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.cap_vrfction_acct_bank_id is '验资账户银行编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.make_acct_bank_acct_id is '上帐银行账户编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.make_acct_bank_acct_num_name is '上帐银行账号名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.keep_acct_bank_acct_id is '下帐银行账户编号';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.keep_acct_bank_acct_num_name is '下帐银行账号名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.trust_org_open_bank_name is '托管机构开户行名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.trust_org_name is '托管机构名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.remark_1 is '备注1';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_finc_prod_clear_acct_info.etl_timestamp is 'ETL处理时间戳';
