/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cap_supv_batch_tot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cap_supv_batch_tot
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cap_supv_batch_tot purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_supv_batch_tot(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_id varchar2(100) -- 批次编号
    ,batch_name_cd varchar2(1000) -- 批次名称代码
    ,batch_type_cd varchar2(250) -- 批次类型代码
    ,cap_src_cd varchar2(60) -- 资金来源代码
    ,coprator_id varchar2(100) -- 合作商编号
    ,check_entry_dt date -- 对账日期
    ,trdpty_batch_id varchar2(250) -- 第三方批次编号
    ,trdpty_flow_num varchar2(250) -- 第三方流水号
    ,submit_data_tot number(30,2) -- 提交数据总笔数
    ,submit_data_tot_amt number(30,2) -- 提交数据总金额
    ,rest_data_tot number(30,2) -- 结果数据总笔数
    ,rest_data_tot_amt number(30,2) -- 结果数据总金额
    ,in_gold_submit_tot number(30,2) -- 入金提交总笔数
    ,in_gold_submit_tot_amt number(30,2) -- 入金提交总金额
    ,wdraw_submit_tot number(30,2) -- 出金提交总笔数
    ,wdraw_submit_tot_amt number(30,2) -- 出金提交总金额
    ,sucs_cnt number(30,2) -- 成功笔数
    ,sucs_amt number(30,2) -- 成功金额
    ,fail_cnt number(30,2) -- 失败笔数
    ,fail_amt number(30,2) -- 失败金额
    ,submit_tot_guar_amt number(30,2) -- 提交总担保金额
    ,sucs_guar_amt number(30,2) -- 成功担保金额
    ,resp_code varchar2(250) -- 响应码
    ,resp_info varchar2(4000) -- 响应信息
    ,tran_org_id varchar2(250) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_dt date -- 交易日期
    ,init_create_dt date -- 最初创建日期
    ,init_create_affair_dt date -- 最初创建事务日期
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_affair_dt date -- 最后修改事务日期
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_cap_supv_batch_tot to ${icl_schema};
grant select on ${iml_schema}.evt_cap_supv_batch_tot to ${idl_schema};
grant select on ${iml_schema}.evt_cap_supv_batch_tot to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cap_supv_batch_tot is '资金监管批次汇总';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.batch_id is '批次编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.batch_name_cd is '批次名称代码';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.batch_type_cd is '批次类型代码';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.coprator_id is '合作商编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.trdpty_batch_id is '第三方批次编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.trdpty_flow_num is '第三方流水号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.submit_data_tot is '提交数据总笔数';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.submit_data_tot_amt is '提交数据总金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.rest_data_tot is '结果数据总笔数';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.rest_data_tot_amt is '结果数据总金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.in_gold_submit_tot is '入金提交总笔数';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.in_gold_submit_tot_amt is '入金提交总金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.wdraw_submit_tot is '出金提交总笔数';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.wdraw_submit_tot_amt is '出金提交总金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.sucs_amt is '成功金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.fail_cnt is '失败笔数';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.fail_amt is '失败金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.submit_tot_guar_amt is '提交总担保金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.sucs_guar_amt is '成功担保金额';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.resp_code is '响应码';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.resp_info is '响应信息';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.init_create_affair_dt is '最初创建事务日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.final_modif_affair_dt is '最后修改事务日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.remark is '备注';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cap_supv_batch_tot.etl_timestamp is 'ETL处理时间戳';
