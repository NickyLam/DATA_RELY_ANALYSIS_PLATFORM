/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_alterbalance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_alterbalance
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_alterbalance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_alterbalance(
    baretrade_id number(22,0) -- 引用表ID
    ,baretradename varchar2(60) -- 引用表名
    ,alterbalance_id number(22,0) -- 引用表2ID
    ,aspclient_id number(22,0) -- 所属部门ID
    ,keepfolder_id number(22,0) -- 账户ID
    ,stdtrade_id number(22,0) -- 引用表3ID
    ,acccode number(22,0) -- 业务类型代码
    ,assettype varchar2(30) -- 资产类别
    ,buztype varchar2(30) -- 业务类别
    ,majorassetcode varchar2(30) -- 主资产代码
    ,minorassetcode varchar2(30) -- 次资产代码
    ,settledate number(8,0) -- 实际收付日期
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
    ,lastmodified timestamp -- 最后变更时间
    ,occuramount number -- 发生金额
    ,alterbalance_id_rev number(22,0) -- 上一笔的ALTERBALANCE_ID
    ,rev_flag varchar2(2) -- 冲账标志
    ,reservevalue1 number -- 备选值1
    ,reservevalue2 number -- 备选值2
    ,bidx number(22,0) -- 分录规则分支编号
    ,aondealtype varchar2(30) -- 备用字段
    ,chargeexpense number -- 
    ,chargeincome number -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_tbs_v_alterbalance to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_alterbalance to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_alterbalance to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_alterbalance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_alterbalance is '变动明细';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.baretrade_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.baretradename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.alterbalance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.aspclient_id is '所属部门ID';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.stdtrade_id is '引用表3ID';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.acccode is '业务类型代码';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.buztype is '业务类别';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.majorassetcode is '主资产代码';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.minorassetcode is '次资产代码';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.settledate is '实际收付日期';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.holdposition is '持有仓位';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.holdfaceamount is '持有面额';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.cleanpricecost is '净价成本';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.interestadjust is '利息调整';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.fairvaluealter is '公允价值变动';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.interestcost is '利息成本';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.dirtypricecost is '全价成本';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.impairment is '减值准备';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.priceearning is '价差收益';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.amortizeearning is '摊销收益';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.interestearning is '利息收益';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.fairvalueincome is '公允价值变动损益';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.impairmentlost is '减值损失';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.tradeexpense is '交易费用';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.realrate is '实际利率';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.valuedate is '起息日期';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.maturitydate is '到期日期';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.lastmodified is '最后变更时间';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.occuramount is '发生金额';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.alterbalance_id_rev is '上一笔的ALTERBALANCE_ID';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.rev_flag is '冲账标志';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.reservevalue1 is '备选值1';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.reservevalue2 is '备选值2';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.bidx is '分录规则分支编号';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.aondealtype is '备用字段';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.chargeexpense is '';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.chargeincome is '';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_tbs_v_alterbalance.etl_timestamp is 'ETL处理时间戳';
