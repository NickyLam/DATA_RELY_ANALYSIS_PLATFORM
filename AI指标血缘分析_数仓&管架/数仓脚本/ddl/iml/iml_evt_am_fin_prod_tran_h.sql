/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_am_fin_prod_tran_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_am_fin_prod_tran_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_am_fin_prod_tran_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_am_fin_prod_tran_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_id varchar2(100) -- 交易编号
    ,bus_type_cd varchar2(60) -- 业务类型代码
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,prod_cate_cd varchar2(60) -- 产品类别代码
    ,brch_seq_num varchar2(100) -- 分支序号
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,dlvy_dt date -- 交割日期
    ,clear_ped_cd varchar2(30) -- 清算周期代码
    ,curr_cd varchar2(60) -- 币种代码
    ,nv_dt date -- 净值日期
    ,corp_net_price number(30,2) -- 单位净价
    ,corp_int number(30,2) -- 单位利息
    ,corp_full_price number(30,2) -- 单位全价
    ,corp_fac_val number(30,2) -- 单位面值
    ,net_price_tot number(30,2) -- 净价总额
    ,tran_lot number(30,2) -- 交易份额
    ,tran_pric number(30,2) -- 交易本金
    ,int_tot number(30,2) -- 利息总额
    ,full_price_tot number(30,2) -- 全价总额
    ,tran_amt number(30,2) -- 交易金额
    ,tot_tran_fee number(30,2) -- 总交易费用
    ,tran_type_cd varchar2(60) -- 交易类型代码
    ,exp_yld_rat number(30,2) -- 到期收益率
    ,ex_yld_rat number(30,2) -- 行权收益率
    ,invest_aim_cd varchar2(60) -- 投资目的代码
    ,tran_status_cd varchar2(60) -- 交易状态代码
    ,revo_flg varchar2(10) -- 撤销标志
    ,init_tran_id varchar2(100) -- 原交易编号
    ,payoff_flg varchar2(10) -- 结清标志
    ,tot_tran_id varchar2(100) -- 汇总交易编号
    ,rev_tran_id varchar2(100) -- 反向交易编号
    ,front_tran_id varchar2(100) -- 前置交易编号
    ,pass_id varchar2(100) -- 通道编号
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,ext_tran_flg varchar2(10) -- 外部交易标志
    ,tran_site_cd varchar2(60) -- 交易场所代码
    ,tran_plat_cd varchar2(60) -- 交易平台代码
    ,market_type_cd varchar2(60) -- 市场类型代码
    ,dealer_name varchar2(60) -- 交易员名称
    ,cntpty_dealer_name varchar2(250) -- 对手方交易员名称
    ,secu_mgmt_acct_id varchar2(100) -- 证券管理户编号
    ,rela_sys_tran_id varchar2(100) -- 关联系统交易编号
    ,cashflow_id varchar2(100) -- 现金流编号
    ,rgst_trust_org_cd varchar2(60) -- 登记托管机构代码
    ,remark varchar2(4000) -- 备注
    ,revo_comnt varchar2(1000) -- 撤销说明
    ,creator_name varchar2(20) -- 创建人名称
    ,create_dept varchar2(60) -- 创建部门
    ,create_tm timestamp -- 创建时间
    ,updater_name varchar2(20) -- 更新人名称
    ,update_tm timestamp -- 更新时间
    ,dlvy_type_cd varchar2(60) -- 交付类型代码
    ,pay_dt date -- 交付日期
    ,splt_bf_tran_id varchar2(100) -- 拆分前交易编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
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
grant select on ${iml_schema}.evt_am_fin_prod_tran_h to ${icl_schema};
grant select on ${iml_schema}.evt_am_fin_prod_tran_h to ${idl_schema};
grant select on ${iml_schema}.evt_am_fin_prod_tran_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_am_fin_prod_tran_h is '资管金融产品交易历史';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_id is '交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.brch_seq_num is '分支序号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.value_dt is '起息日期';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.dlvy_dt is '交割日期';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.clear_ped_cd is '清算周期代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.nv_dt is '净值日期';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.corp_net_price is '单位净价';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.corp_int is '单位利息';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.corp_full_price is '单位全价';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.corp_fac_val is '单位面值';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.net_price_tot is '净价总额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_pric is '交易本金';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.int_tot is '利息总额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.full_price_tot is '全价总额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tot_tran_fee is '总交易费用';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.exp_yld_rat is '到期收益率';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.ex_yld_rat is '行权收益率';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.invest_aim_cd is '投资目的代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.revo_flg is '撤销标志';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.init_tran_id is '原交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.payoff_flg is '结清标志';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tot_tran_id is '汇总交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.rev_tran_id is '反向交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.front_tran_id is '前置交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.pass_id is '通道编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.ext_tran_flg is '外部交易标志';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_site_cd is '交易场所代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.tran_plat_cd is '交易平台代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.market_type_cd is '市场类型代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.dealer_name is '交易员名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.cntpty_dealer_name is '对手方交易员名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.secu_mgmt_acct_id is '证券管理户编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.rela_sys_tran_id is '关联系统交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.cashflow_id is '现金流编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.rgst_trust_org_cd is '登记托管机构代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.remark is '备注';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.revo_comnt is '撤销说明';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.creator_name is '创建人名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.create_dept is '创建部门';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.create_tm is '创建时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.updater_name is '更新人名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.update_tm is '更新时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.dlvy_type_cd is '交付类型代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.pay_dt is '交付日期';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.splt_bf_tran_id is '拆分前交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_h.etl_timestamp is 'ETL处理时间戳';
