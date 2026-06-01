/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_anony_click_match_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_anony_click_match_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_anony_click_match_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_anony_click_match_batch(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,match_batch_ser_num varchar2(100) -- 匹配批次序列号
    ,appl_batch_ser_num varchar2(100) -- 申请批次序列号
    ,ctr_nt_ser_num varchar2(100) -- 成交单序列号
    ,match_batch_id varchar2(100) -- 匹配批次编号
    ,prod_id varchar2(100) -- 产品编号
    ,std_prod_id varchar2(500) -- 标准产品编号
    ,ctr_nt_id varchar2(100) -- 成交单编号
    ,bag_way_cd varchar2(30) -- 成交方式代码
    ,bag_tm timestamp -- 成交时间
    ,ctr_nt_status_cd varchar2(30) -- 成交单状态代码
    ,bill_tot_cnt number(10) -- 票据总张数
    ,bill_tot_amt number(30,2) -- 票据总金额
    ,quot_bill_id varchar2(100) -- 报价单编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,ghb_org_cd varchar2(100) -- 本方机构代码
    ,ghb_non_lp_prod_id varchar2(100) -- 本方非法人产编号
    ,ghb_tran_teller_id varchar2(100) -- 本方交易柜员编号
    ,cntpty_org_id varchar2(100) -- 对方机构编号
    ,cntpty_non_lp_prod_id varchar2(100) -- 对方非法人产品编号
    ,cntpty_tran_teller_id varchar2(100) -- 对方交易柜员编号
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,bill_attr_cd varchar2(30) -- 票据属性代码
    ,repo_amt number(30,2) -- 回购金额
    ,tenor_breed_cd varchar2(30) -- 期限品种代码
    ,repo_tenor number(18,6) -- 回购期限
    ,clear_speed_cd varchar2(30) -- 清算速度代码
    ,clear_type_cd varchar2(30) -- 清算类型代码
    ,latest_fst_stl_tm timestamp -- 最晚首期结算时间
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,fst_stl_amt number(30,2) -- 首期结算金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,fst_stl_dt date -- 首期结算日期
    ,exp_stl_dt date -- 到期结算日期
    ,repo_int_rat number(18,8) -- 回购利率
    ,int_paybl number(30,2) -- 应付利息
    ,repo_yld_rat number(18,6) -- 回购收益率
    ,draw_bill_stop_tm timestamp -- 提票截止时间
    ,crdt_main_type_cd varchar2(30) -- 信用主体类型代码
    ,dept_id varchar2(100) -- 部门编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,msg_status_cd varchar2(30) -- 报文状态代码
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,final_modif_tm timestamp -- 最后修改时间
    ,ibank_crdt_lmt_ocup_status_cd varchar2(30) -- 同业授信额度占用状态代码
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
grant select on ${iml_schema}.evt_anony_click_match_batch to ${icl_schema};
grant select on ${iml_schema}.evt_anony_click_match_batch to ${idl_schema};
grant select on ${iml_schema}.evt_anony_click_match_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_anony_click_match_batch is '票据质押式回购匿名点击匹配批次';
comment on column ${iml_schema}.evt_anony_click_match_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.match_batch_ser_num is '匹配批次序列号';
comment on column ${iml_schema}.evt_anony_click_match_batch.appl_batch_ser_num is '申请批次序列号';
comment on column ${iml_schema}.evt_anony_click_match_batch.ctr_nt_ser_num is '成交单序列号';
comment on column ${iml_schema}.evt_anony_click_match_batch.match_batch_id is '匹配批次编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.prod_id is '产品编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.bag_way_cd is '成交方式代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.bag_tm is '成交时间';
comment on column ${iml_schema}.evt_anony_click_match_batch.ctr_nt_status_cd is '成交单状态代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.bill_tot_cnt is '票据总张数';
comment on column ${iml_schema}.evt_anony_click_match_batch.bill_tot_amt is '票据总金额';
comment on column ${iml_schema}.evt_anony_click_match_batch.quot_bill_id is '报价单编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.ghb_org_cd is '本方机构代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.ghb_non_lp_prod_id is '本方非法人产编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.ghb_tran_teller_id is '本方交易柜员编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.cntpty_org_id is '对方机构编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.cntpty_non_lp_prod_id is '对方非法人产品编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.cntpty_tran_teller_id is '对方交易柜员编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.bill_attr_cd is '票据属性代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.repo_amt is '回购金额';
comment on column ${iml_schema}.evt_anony_click_match_batch.tenor_breed_cd is '期限品种代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.repo_tenor is '回购期限';
comment on column ${iml_schema}.evt_anony_click_match_batch.clear_speed_cd is '清算速度代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.clear_type_cd is '清算类型代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.latest_fst_stl_tm is '最晚首期结算时间';
comment on column ${iml_schema}.evt_anony_click_match_batch.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.fst_stl_amt is '首期结算金额';
comment on column ${iml_schema}.evt_anony_click_match_batch.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.evt_anony_click_match_batch.fst_stl_dt is '首期结算日期';
comment on column ${iml_schema}.evt_anony_click_match_batch.exp_stl_dt is '到期结算日期';
comment on column ${iml_schema}.evt_anony_click_match_batch.repo_int_rat is '回购利率';
comment on column ${iml_schema}.evt_anony_click_match_batch.int_paybl is '应付利息';
comment on column ${iml_schema}.evt_anony_click_match_batch.repo_yld_rat is '回购收益率';
comment on column ${iml_schema}.evt_anony_click_match_batch.draw_bill_stop_tm is '提票截止时间';
comment on column ${iml_schema}.evt_anony_click_match_batch.crdt_main_type_cd is '信用主体类型代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.dept_id is '部门编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_anony_click_match_batch.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.msg_status_cd is '报文状态代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_anony_click_match_batch.ibank_crdt_lmt_ocup_status_cd is '同业授信额度占用状态代码';
comment on column ${iml_schema}.evt_anony_click_match_batch.start_dt is '开始时间';
comment on column ${iml_schema}.evt_anony_click_match_batch.end_dt is '结束时间';
comment on column ${iml_schema}.evt_anony_click_match_batch.id_mark is '增删标志';
comment on column ${iml_schema}.evt_anony_click_match_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_anony_click_match_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_anony_click_match_batch.etl_timestamp is 'ETL处理时间戳';
