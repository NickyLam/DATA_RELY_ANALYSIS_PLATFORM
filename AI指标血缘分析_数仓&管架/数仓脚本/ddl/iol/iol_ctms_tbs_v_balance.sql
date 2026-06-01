/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_balance(
    baretrade_id number -- 引用表ID
    ,baretradename varchar2(60) -- 引用表名
    ,balance_id number -- 引用表2ID
    ,alterbalance_id number -- 引用表3ID
    ,aspclient_id number -- 部门ID
    ,keepfolder_id number -- 账户ID
    ,settledate number(8,0) -- 结算日期
    ,assettype varchar2(30) -- 资产类别
    ,buztype varchar2(30) -- 业务类别
    ,majorassetcode varchar2(30) -- 主资产代码
    ,minorassetcode varchar2(30) -- 次资产代码
    ,holdposition number -- 持有仓位
    ,holdfaceamount number -- 持有面额
    ,cleanpricecost number -- 净价成本
    ,interestadjust number -- 利息调整
    ,fairvaluealter number -- 公允价值变动
    ,interestcost number -- 利息成本
    ,dirtypricecost number -- 全价成本
    ,impairment number -- 减值准备
    ,priceearning number -- 价差收益
    ,amortizeearning number -- 摊销收益
    ,interestearning number -- 利息收益
    ,fairvalueincome number -- 公允价值变动损益
    ,impairmentlost number -- 减值损失
    ,tradeexpense number -- 交易费用
    ,realrate number -- 实际利率
    ,valuedate number(8,0) -- 起息日期
    ,maturitydate number(8,0) -- 到期日期
    ,lastmodified timestamp -- 最后更新时间
    ,occuramount number -- 发生金额
    ,balance_id_prev number -- 上一笔的Balance_id
    ,rev_flag varchar2(2) -- 冲账标志
    ,reservevalue1 number -- 备选值1
    ,reservevalue2 number -- 备选值2
    ,chargeincome number -- 手续费收入
    ,chargeexpense number -- 手续费支出
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_tbs_v_balance to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_balance to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_balance to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_balance is '资产-余额';
comment on column ${iol_schema}.ctms_tbs_v_balance.baretrade_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_balance.baretradename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_balance.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_balance.alterbalance_id is '引用表3ID';
comment on column ${iol_schema}.ctms_tbs_v_balance.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_v_balance.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_balance.settledate is '结算日期';
comment on column ${iol_schema}.ctms_tbs_v_balance.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_balance.buztype is '业务类别';
comment on column ${iol_schema}.ctms_tbs_v_balance.majorassetcode is '主资产代码';
comment on column ${iol_schema}.ctms_tbs_v_balance.minorassetcode is '次资产代码';
comment on column ${iol_schema}.ctms_tbs_v_balance.holdposition is '持有仓位';
comment on column ${iol_schema}.ctms_tbs_v_balance.holdfaceamount is '持有面额';
comment on column ${iol_schema}.ctms_tbs_v_balance.cleanpricecost is '净价成本';
comment on column ${iol_schema}.ctms_tbs_v_balance.interestadjust is '利息调整';
comment on column ${iol_schema}.ctms_tbs_v_balance.fairvaluealter is '公允价值变动';
comment on column ${iol_schema}.ctms_tbs_v_balance.interestcost is '利息成本';
comment on column ${iol_schema}.ctms_tbs_v_balance.dirtypricecost is '全价成本';
comment on column ${iol_schema}.ctms_tbs_v_balance.impairment is '减值准备';
comment on column ${iol_schema}.ctms_tbs_v_balance.priceearning is '价差收益';
comment on column ${iol_schema}.ctms_tbs_v_balance.amortizeearning is '摊销收益';
comment on column ${iol_schema}.ctms_tbs_v_balance.interestearning is '利息收益';
comment on column ${iol_schema}.ctms_tbs_v_balance.fairvalueincome is '公允价值变动损益';
comment on column ${iol_schema}.ctms_tbs_v_balance.impairmentlost is '减值损失';
comment on column ${iol_schema}.ctms_tbs_v_balance.tradeexpense is '交易费用';
comment on column ${iol_schema}.ctms_tbs_v_balance.realrate is '实际利率';
comment on column ${iol_schema}.ctms_tbs_v_balance.valuedate is '起息日期';
comment on column ${iol_schema}.ctms_tbs_v_balance.maturitydate is '到期日期';
comment on column ${iol_schema}.ctms_tbs_v_balance.lastmodified is '最后更新时间';
comment on column ${iol_schema}.ctms_tbs_v_balance.occuramount is '发生金额';
comment on column ${iol_schema}.ctms_tbs_v_balance.balance_id_prev is '上一笔的Balance_id';
comment on column ${iol_schema}.ctms_tbs_v_balance.rev_flag is '冲账标志';
comment on column ${iol_schema}.ctms_tbs_v_balance.reservevalue1 is '备选值1';
comment on column ${iol_schema}.ctms_tbs_v_balance.reservevalue2 is '备选值2';
comment on column ${iol_schema}.ctms_tbs_v_balance.chargeincome is '手续费收入';
comment on column ${iol_schema}.ctms_tbs_v_balance.chargeexpense is '手续费支出';
comment on column ${iol_schema}.ctms_tbs_v_balance.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_balance.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_balance.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_balance.etl_timestamp is 'ETL处理时间戳';
