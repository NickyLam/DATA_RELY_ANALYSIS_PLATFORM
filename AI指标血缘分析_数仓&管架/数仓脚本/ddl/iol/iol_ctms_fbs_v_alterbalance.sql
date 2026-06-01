/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_alterbalance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_alterbalance
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_alterbalance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_alterbalance(
    alterbalance_id number(22,0) -- 变动明细唯一识别代码
    ,aspclient_id number(22,0) -- 部门代码
    ,keepfolder_id number(22,0) -- 后台账户代码
    ,acccode number(22,0) -- 会计事件代码
    ,assettype varchar2(96) -- 资产类别
    ,buztype varchar2(60) -- 业务类别
    ,majorassetcode varchar2(96) -- 主资产代码
    ,minorassetcode varchar2(96) -- 次资产代码
    ,settledate number(8,0) -- 业务发生日期
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
    ,chargeincome number -- 手续费收入
    ,chargeexpense number -- 手续费支出
    ,valuedate number(8,0) -- 起息日
    ,maturitydate number(8,0) -- 到期日
    ,lastmodified timestamp -- 更新时间
    ,occuramount number -- 发生金额
    ,amortizationfactor number(22,0) -- 摊销调整因子
    ,alterbalance_id_prev number(22,0) -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
    ,alterbalance_id_rev number(22,0) -- 指向被冲回的变动交易
    ,rev_flag varchar2(2) -- 标注本次变动是否为冲回重出后的。Y：是
    ,bs_flag varchar2(2) -- 无用
    ,bs_deal_tablename varchar2(60) -- 无用
    ,bs_deal_id number(22,0) -- 无用
    ,reservevalue1 number -- 备选值1
    ,reservevalue2 number -- 备选值2
    ,event_source_name varchar2(72) -- 会计事件源名称
    ,event_source_id varchar2(3000) -- 会计事件源交易代码：前台原始交易代码
    ,event_source_type varchar2(48) -- 会计事件源类别
    ,counterparty varchar2(192) -- 交易对手
    ,day_end_date number(8,0) -- 日终出账日期
    ,out_from varchar2(384) -- 非系统自动产生的来源
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
grant select on ${iol_schema}.ctms_fbs_v_alterbalance to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_alterbalance to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_alterbalance to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_alterbalance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_alterbalance is '变动明细';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.alterbalance_id is '变动明细唯一识别代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.aspclient_id is '部门代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.keepfolder_id is '后台账户代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.acccode is '会计事件代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.assettype is '资产类别';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.buztype is '业务类别';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.majorassetcode is '主资产代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.minorassetcode is '次资产代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.settledate is '业务发生日期';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.holdposition is '持有仓位';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.holdfaceamount is '持有面额';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.cleanpricecost is '净价成本';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.interestadjust is '利息调整';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.fairvaluealter is '公允价值变动';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.interestcost is '利息成本';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.dirtypricecost is '全价成本';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.impairment is '减值准备';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.priceearning is '价差收益';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.amortizeearning is '摊销收益';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.interestearning is '利息收益';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.fairvalueincome is '公允价值变动损益';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.impairmentlost is '减值损失';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.tradeexpense is '交易费用';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.realrate is '实际利率';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.chargeincome is '手续费收入';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.chargeexpense is '手续费支出';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.valuedate is '起息日';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.maturitydate is '到期日';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.lastmodified is '更新时间';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.occuramount is '发生金额';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.amortizationfactor is '摊销调整因子';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.alterbalance_id_prev is '指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.alterbalance_id_rev is '指向被冲回的变动交易';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.rev_flag is '标注本次变动是否为冲回重出后的。Y：是';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.bs_flag is '无用';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.bs_deal_tablename is '无用';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.bs_deal_id is '无用';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.reservevalue1 is '备选值1';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.reservevalue2 is '备选值2';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.event_source_name is '会计事件源名称';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.event_source_id is '会计事件源交易代码：前台原始交易代码';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.event_source_type is '会计事件源类别';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.counterparty is '交易对手';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.day_end_date is '日终出账日期';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.out_from is '非系统自动产生的来源';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_alterbalance.etl_timestamp is 'ETL处理时间戳';
