/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_dep_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_dep_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_dep_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_dep_acct_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_sub_acct_num varchar2(60) -- 客户账户子户号
    ,open_bank_no varchar2(60) -- 开户行行号
    ,open_bank_name varchar2(250) -- 开户行名称
    ,cont_id varchar2(60) -- 合约编号
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,int_accr_way_cd varchar2(10) -- 计息方式代码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,sav_type_cd varchar2(60) -- 储种代码
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,dep_term varchar2(10) -- 存期
    ,dep_term_tenor_type_cd varchar2(10) -- 存期期限类型代码
    ,dep_term_days number(10) -- 存期天数
    ,seg_int_accr_flg varchar2(10) -- 分段计息标志
    ,onl_bus_flg varchar2(10) -- 线上业务标志
    ,last_int_set_dt date -- 上次结息日期
    ,next_int_set_dt date -- 下次结息日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,nomal_int_rat number(18,8) -- 正常利率
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,part_unexp_draw_int_rat number(18,8) -- 部分提前支取利率
    ,part_unexp_draw_surp_int_rat number(18,8) -- 部分提前支取剩余部分利率
    ,advd_wdraw_flg varchar2(10) -- 可提前支取标志
    ,earliest_advd_wdraw_dt date -- 最早可提前支取日期
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_ibank_dep_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_dep_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_dep_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_dep_acct_info is '同业存放账户信息';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.cust_sub_acct_num is '客户账户子户号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.open_bank_no is '开户行行号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.open_bank_name is '开户行名称';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.cont_id is '合约编号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.int_set_way_cd is '结息方式代码';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.int_accr_way_cd is '计息方式代码';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.sav_type_cd is '储种代码';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.dep_term is '存期';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.dep_term_tenor_type_cd is '存期期限类型代码';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.dep_term_days is '存期天数';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.seg_int_accr_flg is '分段计息标志';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.onl_bus_flg is '线上业务标志';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.last_int_set_dt is '上次结息日期';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.next_int_set_dt is '下次结息日期';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.nomal_int_rat is '正常利率';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.part_unexp_draw_int_rat is '部分提前支取利率';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.part_unexp_draw_surp_int_rat is '部分提前支取剩余部分利率';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.advd_wdraw_flg is '可提前支取标志';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.earliest_advd_wdraw_dt is '最早可提前支取日期';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_dep_acct_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_dep_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_dep_acct_info.etl_timestamp is 'ETL处理时间戳';
