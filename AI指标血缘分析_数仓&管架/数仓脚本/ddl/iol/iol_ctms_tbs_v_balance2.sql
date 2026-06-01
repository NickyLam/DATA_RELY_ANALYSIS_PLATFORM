/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_balance2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_balance2
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_balance2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_balance2(
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
grant select on ${iol_schema}.ctms_tbs_v_balance2 to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_balance2 to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_balance2 to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_balance2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_balance2 is '资产-余额2';
comment on column ${iol_schema}.ctms_tbs_v_balance2.baretrade_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_balance2.baretradename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_balance2.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_balance2.alterbalance_id is '引用表3ID';
comment on column ${iol_schema}.ctms_tbs_v_balance2.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_v_balance2.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_balance2.settledate is '结算日期';
comment on column ${iol_schema}.ctms_tbs_v_balance2.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_balance2.buztype is '业务类别';
comment on column ${iol_schema}.ctms_tbs_v_balance2.majorassetcode is '主资产代码';
comment on column ${iol_schema}.ctms_tbs_v_balance2.minorassetcode is '次资产代码';
comment on column ${iol_schema}.ctms_tbs_v_balance2.holdposition is '持有仓位';
comment on column ${iol_schema}.ctms_tbs_v_balance2.holdfaceamount is '持有面额';
comment on column ${iol_schema}.ctms_tbs_v_balance2.cleanpricecost is '净价成本';
comment on column ${iol_schema}.ctms_tbs_v_balance2.interestadjust is '利息调整';
comment on column ${iol_schema}.ctms_tbs_v_balance2.fairvaluealter is '公允价值变动';
comment on column ${iol_schema}.ctms_tbs_v_balance2.interestcost is '利息成本';
comment on column ${iol_schema}.ctms_tbs_v_balance2.dirtypricecost is '全价成本';
comment on column ${iol_schema}.ctms_tbs_v_balance2.impairment is '减值准备';
comment on column ${iol_schema}.ctms_tbs_v_balance2.priceearning is '价差收益';
comment on column ${iol_schema}.ctms_tbs_v_balance2.amortizeearning is '摊销收益';
comment on column ${iol_schema}.ctms_tbs_v_balance2.interestearning is '利息收益';
comment on column ${iol_schema}.ctms_tbs_v_balance2.fairvalueincome is '公允价值变动损益';
comment on column ${iol_schema}.ctms_tbs_v_balance2.impairmentlost is '减值损失';
comment on column ${iol_schema}.ctms_tbs_v_balance2.tradeexpense is '交易费用';
comment on column ${iol_schema}.ctms_tbs_v_balance2.realrate is '实际利率';
comment on column ${iol_schema}.ctms_tbs_v_balance2.valuedate is '起息日期';
comment on column ${iol_schema}.ctms_tbs_v_balance2.maturitydate is '到期日期';
comment on column ${iol_schema}.ctms_tbs_v_balance2.lastmodified is '最后更新时间';
comment on column ${iol_schema}.ctms_tbs_v_balance2.occuramount is '发生金额';
comment on column ${iol_schema}.ctms_tbs_v_balance2.balance_id_prev is '上一笔的Balance_id';
comment on column ${iol_schema}.ctms_tbs_v_balance2.rev_flag is '冲账标志';
comment on column ${iol_schema}.ctms_tbs_v_balance2.reservevalue1 is '备选值1';
comment on column ${iol_schema}.ctms_tbs_v_balance2.reservevalue2 is '备选值2';
comment on column ${iol_schema}.ctms_tbs_v_balance2.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_balance2.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_balance2.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_balance2.etl_timestamp is 'ETL处理时间戳';
