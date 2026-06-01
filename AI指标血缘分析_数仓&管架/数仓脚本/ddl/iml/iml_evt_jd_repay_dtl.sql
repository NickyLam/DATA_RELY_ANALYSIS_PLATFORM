/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_jd_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_jd_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_jd_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_jd_repay_dtl(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,jd_prod_cd varchar2(60) -- 京东产品代码
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,dubil_id varchar2(60) -- 借据编号
    ,inst_odd_no varchar2(60) -- 分期单号
    ,repay_dt date -- 还款日期
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,acm_rpbl_pric_amt number(30,8) -- 累计应还本金
    ,paid_pric_amt number(30,8) -- 实还本金
    ,acm_rpbl_int_bal number(30,8) -- 累计应还利息
    ,paid_int_amt number(30,8) -- 实还利息
    ,acm_rpbl_pnlt_bal number(30,8) -- 累计应还罚息
    ,paid_pnlt_amt number(30,8) -- 实还罚息
    ,repay_perds number(10) -- 还款期数
    ,surp_repay_perds number(10) -- 剩余还款期数
    ,repay_type_cd varchar2(10) -- 还款类型代码
    ,serv_fee number(30,8) -- 服务费
    ,coll_fee number(30,8) -- 催收费
    ,prod_id varchar2(60) -- 产品编号
    ,recvbl number(30,8) -- 资方应收固收
    ,recvbl_nomal_prft number(30,8) -- 资方应收分润正常收益
    ,recvbl_ovdue_prft number(30,8) -- 资方应收分润逾期收益
    ,acm_rpbl_penalty number(30,8) -- 累计应还违约金
    ,paid_penalty number(30,8) -- 实还违约金
    ,ovdue_days number(10) -- 贷款逾期天数
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_jd_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_jd_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_jd_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_jd_repay_dtl is '京东还款明细';
comment on column ${iml_schema}.evt_jd_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_jd_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_jd_repay_dtl.cont_id is '合同编号';
comment on column ${iml_schema}.evt_jd_repay_dtl.jd_prod_cd is '京东产品代码';
comment on column ${iml_schema}.evt_jd_repay_dtl.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.evt_jd_repay_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_jd_repay_dtl.inst_odd_no is '分期单号';
comment on column ${iml_schema}.evt_jd_repay_dtl.repay_dt is '还款日期';
comment on column ${iml_schema}.evt_jd_repay_dtl.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_jd_repay_dtl.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.evt_jd_repay_dtl.acm_rpbl_pric_amt is '累计应还本金';
comment on column ${iml_schema}.evt_jd_repay_dtl.paid_pric_amt is '实还本金';
comment on column ${iml_schema}.evt_jd_repay_dtl.acm_rpbl_int_bal is '累计应还利息';
comment on column ${iml_schema}.evt_jd_repay_dtl.paid_int_amt is '实还利息';
comment on column ${iml_schema}.evt_jd_repay_dtl.acm_rpbl_pnlt_bal is '累计应还罚息';
comment on column ${iml_schema}.evt_jd_repay_dtl.paid_pnlt_amt is '实还罚息';
comment on column ${iml_schema}.evt_jd_repay_dtl.repay_perds is '还款期数';
comment on column ${iml_schema}.evt_jd_repay_dtl.surp_repay_perds is '剩余还款期数';
comment on column ${iml_schema}.evt_jd_repay_dtl.repay_type_cd is '还款类型代码';
comment on column ${iml_schema}.evt_jd_repay_dtl.serv_fee is '服务费';
comment on column ${iml_schema}.evt_jd_repay_dtl.coll_fee is '催收费';
comment on column ${iml_schema}.evt_jd_repay_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_jd_repay_dtl.recvbl is '资方应收固收';
comment on column ${iml_schema}.evt_jd_repay_dtl.recvbl_nomal_prft is '资方应收分润正常收益';
comment on column ${iml_schema}.evt_jd_repay_dtl.recvbl_ovdue_prft is '资方应收分润逾期收益';
comment on column ${iml_schema}.evt_jd_repay_dtl.acm_rpbl_penalty is '累计应还违约金';
comment on column ${iml_schema}.evt_jd_repay_dtl.paid_penalty is '实还违约金';
comment on column ${iml_schema}.evt_jd_repay_dtl.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.evt_jd_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_jd_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_jd_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_jd_repay_dtl.etl_timestamp is 'ETL处理时间戳';
