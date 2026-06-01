/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_acct_lmt_type_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_acct_lmt_type_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_acct_lmt_type_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_acct_lmt_type_para(
    lp_id varchar2(100) -- 法人编号
    ,lmt_type_cd varchar2(30) -- 限制类型代码
    ,lmt_type_descb varchar2(500) -- 限制类型描述
    ,lmt_type_cate_cd varchar2(30) -- 限制类型类别代码
    ,froz_lev varchar2(30) -- 冻结级别
    ,manual_froz_flg varchar2(10) -- 手工冻结标志
    ,manual_unfrz_flg varchar2(10) -- 手工解冻标志
    ,full_amt_stop_pay_flg varchar2(10) -- 全额止付标志
    ,sys_spec_flg varchar2(10) -- 系统专用标志
    ,auth_org_froz_flg varchar2(10) -- 有权机关冻结标志
    ,eod_deduct_flg varchar2(10) -- EOD扣款标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_acct_lmt_type_para to ${icl_schema};
grant select on ${iml_schema}.ref_acct_lmt_type_para to ${idl_schema};
grant select on ${iml_schema}.ref_acct_lmt_type_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_acct_lmt_type_para is '账户限制类型参数表';
comment on column ${iml_schema}.ref_acct_lmt_type_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_acct_lmt_type_para.lmt_type_cd is '限制类型代码';
comment on column ${iml_schema}.ref_acct_lmt_type_para.lmt_type_descb is '限制类型描述';
comment on column ${iml_schema}.ref_acct_lmt_type_para.lmt_type_cate_cd is '限制类型类别代码';
comment on column ${iml_schema}.ref_acct_lmt_type_para.froz_lev is '冻结级别';
comment on column ${iml_schema}.ref_acct_lmt_type_para.manual_froz_flg is '手工冻结标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.manual_unfrz_flg is '手工解冻标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.full_amt_stop_pay_flg is '全额止付标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.sys_spec_flg is '系统专用标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.auth_org_froz_flg is '有权机关冻结标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.eod_deduct_flg is 'EOD扣款标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_acct_lmt_type_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_acct_lmt_type_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_acct_lmt_type_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_acct_lmt_type_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_acct_lmt_type_para.etl_timestamp is 'ETL处理时间戳';
