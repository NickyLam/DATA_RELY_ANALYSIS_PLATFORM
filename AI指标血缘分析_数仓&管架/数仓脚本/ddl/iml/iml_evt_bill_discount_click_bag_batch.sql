/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_discount_click_bag_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_discount_click_bag_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_discount_click_bag_batch(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_ser_num varchar2(100) -- 批次序列号
    ,batch_id varchar2(100) -- 批次编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,bus_dt date -- 业务日期
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,anony_flg varchar2(10) -- 匿名标志
    ,tran_range_cd varchar2(30) -- 交易范围代码
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,bill_attr_cd varchar2(30) -- 票据属性代码
    ,part_bag_option_flg varchar2(10) -- 部分成交选项标志
    ,quot_valid_tm timestamp -- 报价有效时间
    ,stop_stl_tm timestamp -- 截止结算时间
    ,clear_speed_cd varchar2(30) -- 清算速度代码
    ,bill_cnt number(10) -- 票据张数
    ,bill_tot number(30,2) -- 票据总额
    ,yld_rat number(18,6) -- 收益率
    ,weight_avg_surp_tenor number(18,6) -- 加权平均剩余期限
    ,stl_amt number(30,2) -- 转贴现金额
    ,discnt_int_rat number(18,8) -- 贴现利率
    ,int_paybl number(30,2) -- 应付利息
    ,stl_dt date -- 结算日期
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,clear_type_cd varchar2(30) -- 清算类型代码
    ,cntpty_clear_mode varchar2(45) -- 交易对手方清算模式
    ,cntpty_org_cd varchar2(100) -- 交易对手方机构代码
    ,cntpty_non_lp_prod_id varchar2(100) -- 交易对手方非法人产品编号
    ,cntpty_tran_teller_id varchar2(100) -- 交易对手方交易柜员编号
    ,pay_cfm_flg varchar2(10) -- 付款确认标志
    ,shortest_surp_tenor number(18,6) -- 最短剩余期限
    ,lont_surp_tenor number(18,6) -- 最长剩余期限
    ,bill_exp_begin_day date -- 票据到期起始日
    ,bill_exp_stop_day date -- 票据到期截止日
    ,min_singl_fac_val_amt number(30,2) -- 最小单张票面金额
    ,crdt_main_type_cd varchar2(30) -- 信用主体类型代码
    ,crdt_main_code varchar2(1500) -- 信用主体编码
    ,cntpty_type_cd varchar2(1000) -- 交易对手类型代码
    ,acpt_bank_type_cd varchar2(1000) -- 承兑银行类型代码
    ,acpt_bank_id varchar2(1000) -- 承兑银行编号
    ,discnt_bank_type_cd varchar2(1000) -- 贴现银行类型代码
    ,discnt_bank_id varchar2(1000) -- 贴现银行编号
    ,guar_incre_crdt_bk_type_cd varchar2(1000) -- 保证增信行类型代码
    ,guar_incre_crdt_bank_id varchar2(1000) -- 保证增信银行编号
    ,dept_id varchar2(100) -- 部门编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,msg_proc_status_cd varchar2(30) -- 报文处理状态代码
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,final_modif_tm varchar2(100) -- 最后修改时间
    ,prod_id varchar2(100) -- 产品编号
    ,std_prod_id varchar2(500) -- 标准产品编号
    ,ctr_nt_ser_num varchar2(100) -- 成交单序列号
    ,quot_bill_id varchar2(30) -- 报价单编号
    ,click_bag_type_cd varchar2(30) -- 点击成交类型代码
    ,ctr_nt_id varchar2(30) -- 成交单编号
    ,quot_forward_cnt number(10) -- 报价转发次数
    ,batch_type_cd varchar2(30) -- 批次类型代码
    ,ibank_crdt_lmt_ocup_status_cd varchar2(30) -- 同业授信额度占用状态代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
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
grant select on ${iml_schema}.evt_bill_discount_click_bag_batch to ${icl_schema};
grant select on ${iml_schema}.evt_bill_discount_click_bag_batch to ${idl_schema};
grant select on ${iml_schema}.evt_bill_discount_click_bag_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_discount_click_bag_batch is '票据转贴现点击成交批次';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.batch_ser_num is '批次序列号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.batch_id is '批次编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bus_dt is '业务日期';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.anony_flg is '匿名标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.tran_range_cd is '交易范围代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bill_attr_cd is '票据属性代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.part_bag_option_flg is '部分成交选项标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.quot_valid_tm is '报价有效时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.stop_stl_tm is '截止结算时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.clear_speed_cd is '清算速度代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bill_cnt is '票据张数';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bill_tot is '票据总额';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.yld_rat is '收益率';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.weight_avg_surp_tenor is '加权平均剩余期限';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.stl_amt is '转贴现金额';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.discnt_int_rat is '贴现利率';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.int_paybl is '应付利息';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.stl_dt is '结算日期';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.clear_type_cd is '清算类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.cntpty_clear_mode is '交易对手方清算模式';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.cntpty_org_cd is '交易对手方机构代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.cntpty_non_lp_prod_id is '交易对手方非法人产品编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.cntpty_tran_teller_id is '交易对手方交易柜员编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.pay_cfm_flg is '付款确认标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.shortest_surp_tenor is '最短剩余期限';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.lont_surp_tenor is '最长剩余期限';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bill_exp_begin_day is '票据到期起始日';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.bill_exp_stop_day is '票据到期截止日';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.min_singl_fac_val_amt is '最小单张票面金额';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.crdt_main_type_cd is '信用主体类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.crdt_main_code is '信用主体编码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.cntpty_type_cd is '交易对手类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.acpt_bank_type_cd is '承兑银行类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.acpt_bank_id is '承兑银行编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.discnt_bank_type_cd is '贴现银行类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.discnt_bank_id is '贴现银行编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.guar_incre_crdt_bk_type_cd is '保证增信行类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.guar_incre_crdt_bank_id is '保证增信银行编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.dept_id is '部门编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.msg_proc_status_cd is '报文处理状态代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.prod_id is '产品编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.ctr_nt_ser_num is '成交单序列号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.quot_bill_id is '报价单编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.click_bag_type_cd is '点击成交类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.quot_forward_cnt is '报价转发次数';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.batch_type_cd is '批次类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.ibank_crdt_lmt_ocup_status_cd is '同业授信额度占用状态代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.asset_thd_cls_cd is '资产三分类代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_batch.etl_timestamp is 'ETL处理时间戳';
