/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ym_fund_lot_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ym_fund_lot_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ym_fund_lot_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ym_fund_lot_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,serv_plat_abbr varchar2(750) -- 服务平台简称
    ,mercht_id varchar2(100) -- 商户编号
    ,lot_id varchar2(100) -- 份额编号
    ,acct_id varchar2(100) -- 账户编号
    ,ym_riches_acct_id varchar2(100) -- 盈米财富账户编号
    ,mode_pay_id varchar2(100) -- 支付方式编号
    ,fund_cd varchar2(30) -- 基金代码
    ,prod_charge_way_cd varchar2(30) -- 产品收费方式代码
    ,lot_tot number(18,6) -- 份额总数
    ,froz_lot number(18,6) -- 冻结份额
    ,unpaid_prft number(18,6) -- 未付收益
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,inv_port_id varchar2(100) -- 投资组合编号
    ,curr_prft number(18,6) -- 当前收益
    ,acm_prft number(18,6) -- 累计收益
    ,std_prod_id varchar2(100) -- 标准产品编号
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
grant select on ${iml_schema}.agt_ym_fund_lot_h to ${icl_schema};
grant select on ${iml_schema}.agt_ym_fund_lot_h to ${idl_schema};
grant select on ${iml_schema}.agt_ym_fund_lot_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ym_fund_lot_h is '盈米基金份额历史';
comment on column ${iml_schema}.agt_ym_fund_lot_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.serv_plat_abbr is '服务平台简称';
comment on column ${iml_schema}.agt_ym_fund_lot_h.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.lot_id is '份额编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.ym_riches_acct_id is '盈米财富账户编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.mode_pay_id is '支付方式编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.fund_cd is '基金代码';
comment on column ${iml_schema}.agt_ym_fund_lot_h.prod_charge_way_cd is '产品收费方式代码';
comment on column ${iml_schema}.agt_ym_fund_lot_h.lot_tot is '份额总数';
comment on column ${iml_schema}.agt_ym_fund_lot_h.froz_lot is '冻结份额';
comment on column ${iml_schema}.agt_ym_fund_lot_h.unpaid_prft is '未付收益';
comment on column ${iml_schema}.agt_ym_fund_lot_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.agt_ym_fund_lot_h.inv_port_id is '投资组合编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.curr_prft is '当前收益';
comment on column ${iml_schema}.agt_ym_fund_lot_h.acm_prft is '累计收益';
comment on column ${iml_schema}.agt_ym_fund_lot_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_ym_fund_lot_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ym_fund_lot_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ym_fund_lot_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ym_fund_lot_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ym_fund_lot_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ym_fund_lot_h.etl_timestamp is 'ETL处理时间戳';
