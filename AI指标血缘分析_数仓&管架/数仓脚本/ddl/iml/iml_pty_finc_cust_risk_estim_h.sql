/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_finc_cust_risk_estim_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_finc_cust_risk_estim_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_finc_cust_risk_estim_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_finc_cust_risk_estim_h(
    party_id varchar2(250) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,sorc_sys_cd varchar2(30) -- 源系统代码
    ,seq_num varchar2(100) -- 序号
    ,party_rating_type_cd varchar2(30) -- 当事人评级类型代码
    ,rating_level_cd varchar2(100) -- 客户风险承受能力评估等级代码
    ,estim_dt date -- 评估日期
    ,rating_effect_dt date -- 评级生效日期
    ,rating_invalid_dt date -- 评级失效日期
    ,rating_chn_cd varchar2(30) -- 评级渠道代码
    ,non_cnter_chn_buy_high_risk_prod_flg varchar2(10) -- 非柜面渠道购买高风险产品标志
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
grant select on ${iml_schema}.pty_finc_cust_risk_estim_h to ${icl_schema};
grant select on ${iml_schema}.pty_finc_cust_risk_estim_h to ${idl_schema};
grant select on ${iml_schema}.pty_finc_cust_risk_estim_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_finc_cust_risk_estim_h is '理财客户风险评估历史';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.seq_num is '序号';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.party_rating_type_cd is '当事人评级类型代码';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.rating_level_cd is '客户风险承受能力评估等级代码';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.estim_dt is '评估日期';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.rating_effect_dt is '评级生效日期';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.rating_invalid_dt is '评级失效日期';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.rating_chn_cd is '评级渠道代码';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.non_cnter_chn_buy_high_risk_prod_flg is '非柜面渠道购买高风险产品标志';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_finc_cust_risk_estim_h.etl_timestamp is 'ETL处理时间戳';
