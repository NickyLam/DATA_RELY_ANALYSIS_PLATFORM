/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_new_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_new_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_new_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_new_balance(
    baretrade_id number(22,0) -- 
    ,baretradename varchar2(60) -- 
    ,balance_id number(22,0) -- 
    ,alterbalance_id number(22,0) -- 
    ,aspclient_id number(22,0) -- 
    ,keepfolder_id number(22,0) -- 
    ,settledate number(8,0) -- 
    ,assettype varchar2(30) -- 
    ,buztype varchar2(30) -- 
    ,majorassetcode varchar2(30) -- 
    ,minorassetcode varchar2(30) -- 
    ,holdposition number -- 
    ,holdfaceamount number -- 
    ,cleanpricecost number -- 
    ,interestadjust number -- 
    ,fairvaluealter number -- 
    ,interestcost number -- 
    ,dirtypricecost number -- 
    ,impairment number -- 
    ,priceearning number -- 
    ,amortizeearning number -- 
    ,interestearning number -- 
    ,fairvalueincome number -- 
    ,impairmentlost number -- 
    ,tradeexpense number -- 
    ,realrate number -- 
    ,valuedate number(8,0) -- 
    ,maturitydate number(8,0) -- 
    ,lastmodified timestamp -- 
    ,occuramount number -- 
    ,balance_id_prev number(22,0) -- 
    ,rev_flag varchar2(2) -- 
    ,reservevalue1 number -- 
    ,reservevalue2 number -- 
    ,product_code varchar2(75) -- 
    ,chargeincome number -- 手续费收入
    ,chargeexpense number -- 手续费支出
    ,capital_subjectid varchar2(30) -- 本金科目编号
    ,interestcost_subjectid varchar2(30) -- 利息成本科目编号
    ,interestadjust_subjectid varchar2(30) -- 利息调整科目编号
    ,fairvaluealter_subjectid varchar2(30) -- 公允价值变动科目编号
    ,interestearning_subjectid varchar2(30) -- 利息收入科目编号
    ,amortizeearning_subjectid varchar2(30) -- 摊销收益科目编号
    ,fairvalueincome_subjectid varchar2(30) -- 公允价值变动损益科目编号
    ,priceearning_subjectid varchar2(30) -- 价差收益科目编号
    ,arvinterestcost number(22,9) -- 挂账金额
    ,arvinterestcost_subjectid varchar2(48) -- 挂账科目
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
grant select on ${iol_schema}.ctms_tbs_v_new_balance to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_new_balance to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_new_balance to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_new_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_new_balance is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.baretrade_id is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.baretradename is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.balance_id is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.alterbalance_id is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.aspclient_id is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.keepfolder_id is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.settledate is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.assettype is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.buztype is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.majorassetcode is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.minorassetcode is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.holdposition is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.holdfaceamount is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.cleanpricecost is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.interestadjust is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.fairvaluealter is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.interestcost is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.dirtypricecost is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.impairment is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.priceearning is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.amortizeearning is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.interestearning is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.fairvalueincome is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.impairmentlost is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.tradeexpense is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.realrate is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.valuedate is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.maturitydate is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.lastmodified is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.occuramount is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.balance_id_prev is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.rev_flag is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.reservevalue1 is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.reservevalue2 is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.product_code is '';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.chargeincome is '手续费收入';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.chargeexpense is '手续费支出';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.capital_subjectid is '本金科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.interestcost_subjectid is '利息成本科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.interestadjust_subjectid is '利息调整科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.fairvaluealter_subjectid is '公允价值变动科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.interestearning_subjectid is '利息收入科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.amortizeearning_subjectid is '摊销收益科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.fairvalueincome_subjectid is '公允价值变动损益科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.priceearning_subjectid is '价差收益科目编号';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.arvinterestcost is '挂账金额';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.arvinterestcost_subjectid is '挂账科目';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_new_balance.etl_timestamp is 'ETL处理时间戳';
