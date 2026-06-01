/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myhb_ac_summary_trans_01
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myhb_ac_summary_trans_01
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myhb_ac_summary_trans_01 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_ac_summary_trans_01(
    settledate varchar2(8) -- 业务日期
    ,regioncode varchar2(8) -- 行政区划代码
    ,payablefeeamt number(24,6) -- 应付平台服务费汇总金额
    ,feeamt number(24,6) -- 实付平台服务费汇总金额
    ,receivablesubsidyintamt number(24,6) -- 贴息计提(表内)
    ,paidsubsidyintamt number(24,6) -- 实还贴息(表内)
    ,accruedintamt number(24,6) -- 短期正常/逾期90天以内(含)贷款计提每日利息(表内)
    ,nonaccruedintamt number(24,6) -- 短期逾期90天以上贷款计提每日利息(表外)
    ,encashamt number(24,6) -- 当天贷款发放金额
    ,accruedovdprinpnltamt number(24,6) -- 短期逾期90天以内(含)贷款计提每日逾期本金罚息(表内)
    ,nonaccruedovdprinpnltamt number(24,6) -- 短期逾期90天以上贷款计提每日逾期本金罚息(表外)
    ,accruedovdintpnltamt number(24,6) -- 短期逾期90天以内(含)贷款计提每日逾期利息罚息(表内)
    ,nonaccruedovdintpnltamt number(24,6) -- 短期逾期90天以上贷款计提每日逾期利息罚息(表外)
    ,printoovdprinamt number(24,6) -- 正常本金转逾期本金
    ,inttoovdintamt number(24,6) -- 正常利息转逾期利息
    ,nonprintononovdprinamt number(24,6) -- 正常本金(非应计)转逾期本金(非应计)
    ,outinttooutovdintamt number(24,6) -- 正常利息(表外)转逾期利息(表外)
    ,accruedtononprinamt number(24,6) -- 正常本金(应计)转正常本金(非应计)
    ,accruedtononovdprinamt number(24,6) -- 逾期本金(应计)转逾期本金(非应计)
    ,internaltooutintamt number(24,6) -- 正常利息(表内)转正常利息(表外)
    ,internaltooutovdintamt number(24,6) -- 逾期利息(表内)转逾期利息(表外)
    ,internaltooutovdprinpnltamt number(24,6) -- 逾期本金罚息(表内)转逾期本金罚息(表外)
    ,internaltooutovdintpnltamt number(24,6) -- 逾期利息罚息(表内)转逾期利息罚息(表外)
    ,nontoaccruedprinamt number(24,6) -- 正常本金(非应计)转正常本金(应计)
    ,nontoaccruedovdprinamt number(24,6) -- 逾期本金(非应计)转逾期本金(应计)
    ,outtointernalintamt number(24,6) -- 正常利息(表外)转正常利息(表内)
    ,outtointernalovdintamt number(24,6) -- 逾期利息(表外)转逾期利息(表内)
    ,outtointernalovdprinpnltamt number(24,6) -- 逾期本金罚息(表外)转逾本金罚息(表内)
    ,outtointernalovdintpnltamt number(24,6) -- 逾期利息罚息(表外)转逾期利息罚息(表内)
    ,paidprinamt number(24,6) -- 实还正常本金(应计)
    ,paidnonaccruedprinamt number(24,6) -- 实还正常本金(非应计)
    ,paidaccruedovdprinamt number(24,6) -- 实还逾期本金(应计)
    ,paidnonaccruedovdprinamt number(24,6) -- 实还逾期本金(非应计)
    ,paidintamt number(24,6) -- 实还正常利息(表内)
    ,paidoutintamt number(24,6) -- 实还正常利息(表外)
    ,paidinternalovdintamt number(24,6) -- 实还逾期利息(表内)
    ,paidoutovdintamt number(24,6) -- 实还逾期利息(表外)
    ,paidinternalovdprinpnltintamt number(24,6) -- 实还逾期本金罚息(表内)
    ,paidoutovdprinpnltintamt number(24,6) -- 实还逾期本金罚息(表外)
    ,paidinternalovdintpnltintamt number(24,6) -- 实还逾期利息罚息(表内)
    ,paidoutovdintpnltintamt number(24,6) -- 实还逾期利息罚息(表外)
    ,exemptintamt number(24,6) -- 减免正常利息(表内)
    ,exemptoutintamt number(24,6) -- 减免正常利息(表外)
    ,exemptinternalovdintamt number(24,6) -- 减免逾期利息(表内)
    ,exemptoutovdintamt number(24,6) -- 减免逾期利息(表外)
    ,exemptinternalovdprinpnltintamt number(24,6) -- 减免逾期本金罚息(表内)
    ,exemptoutovdprinpnltintamt number(24,6) -- 减免逾期本金罚息(表外)
    ,exemptinternalovdintpnltintamt number(24,6) -- 减免逾期利息罚息(表内)
    ,exemptoutovdintpnltintamt number(24,6) -- 减免逾期利息罚息(表外)
    ,printoprinamtrlv number(24,6) -- 正常本金转正常本金
    ,ovdprintoprinamtrlv number(24,6) -- 逾期本金转正常本金
    ,nontoprinamtrlv number(24,6) -- 正常本金(非应计)转正常本金
    ,nonprintoprinamtrlv number(24,6) -- 逾期本金(非应计)转正常本金
    ,inttointamtrlv number(24,6) -- 正常利息转正常利息
    ,outinttointamtrlv number(24,6) -- 正常利息(表外)转正常利息
    ,ovdinttointamtrlv number(24,6) -- 逾期利息(表内)转正常利息
    ,outovdinttointamtrlv number(24,6) -- 逾期利息(表外)转正常利息
    ,writeoffovdprintoprinamtrlv number(24,6) -- 逾期本金（核销）转正常本金
    ,writeoffovdinttointamtrlv number(24,6) -- 逾期利息（核销）转正常利息
    ,printoprinamtinst number(24,6) -- 正常本金转正常本金
    ,ovdprintoprinamtinst number(24,6) -- 逾期本金转正常本金
    ,nonaccruedprinamtinst number(24,6) -- 正常本金(非应计)转正常本金
    ,nonaccruedtoprinamtinst number(24,6) -- 逾期本金(非应计)转正常本金
    ,writeoffprintoprinamtinst number(24,6) -- 正常本金（核销）转正常本金
    ,printoprinmedium number(24,6) -- 正常本金转正常本金
    ,nonprintoprinmedium number(24,6) -- 正常本金（非应计）转正常本金（应计）
    ,wfprintoprinmedium number(24,6) -- 正常本金（核销）转正常本金（应计）
    ,writeoffnonprinamt number(24,6) -- 已减值正常贷款本金核销
    ,writeoffnonovdprinamt number(24,6) -- 已减值逾期贷款本金核销
    ,writeoffoutintamt number(24,6) -- 正常贷款利息（表外）核销
    ,writeoffoutovdintamt number(24,6) -- 逾期贷款利息（表外）核销
    ,writeoffoutovdprinpnltamt number(24,6) -- 逾期本金罚息（表外）核销
    ,writeoffoutovdintpnltamt number(24,6) -- 逾期利息罚息（表外）核销
    ,writeoffintamt number(24,6) -- 已核销的贷款正常利息计提
    ,writeoffovdprinpnltamt number(24,6) -- 已核销的贷款逾期本金罚息计提
    ,writeoffovdintpnltamt number(24,6) -- 已核销的贷款逾期利息罚息计提
    ,writeoffprintoovdprinamt number(24,6) -- 已核销的贷款本金转逾期
    ,writeoffinttoovdintamt number(24,6) -- 已核销的贷款利息转逾期
    ,paidwriteoffprinamt number(24,6) -- 实还已核销正常本金
    ,paidwriteoffovdprinamt number(24,6) -- 实还已核销逾期本金
    ,paidwriteoffintamt number(24,6) -- 实还已核销正常利息
    ,paidwriteoffovdintamt number(24,6) -- 实还已核销逾期利息
    ,paidwriteoffovdprinpnltintamt number(24,6) -- 实还已核销本金罚息
    ,paidwriteoffovdintpnltintamt number(24,6) -- 实还已核销利息罚息
    ,exemptwriteoffintamt number(24,6) -- 减免已核销正常利息
    ,exemptwriteoffovdintamt number(24,6) -- 减免已核销逾期利息
    ,exemptwriteoffovdprinpnltintamt number(24,6) -- 减免已核销本金罚息
    ,exemptwriteoffovdintpnltintamt number(24,6) -- 减免已核销利息罚息
    ,loantransitdeposit number(24,6) -- 放款待结算调拨回流金额
    ,repaytransitwithdraw number(24,6) -- 还款待结算调拨流入金额
    ,loantransitwithdraw number(24,6) -- 放款待结算调拨回流金额
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
grant select on ${iol_schema}.icms_myhb_ac_summary_trans_01 to ${iml_schema};
grant select on ${iol_schema}.icms_myhb_ac_summary_trans_01 to ${icl_schema};
grant select on ${iol_schema}.icms_myhb_ac_summary_trans_01 to ${idl_schema};
grant select on ${iol_schema}.icms_myhb_ac_summary_trans_01 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myhb_ac_summary_trans_01 is '花呗汇总记账文件';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.settledate is '业务日期';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.payablefeeamt is '应付平台服务费汇总金额';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.feeamt is '实付平台服务费汇总金额';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.receivablesubsidyintamt is '贴息计提(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidsubsidyintamt is '实还贴息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.accruedintamt is '短期正常/逾期90天以内(含)贷款计提每日利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonaccruedintamt is '短期逾期90天以上贷款计提每日利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.encashamt is '当天贷款发放金额';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.accruedovdprinpnltamt is '短期逾期90天以内(含)贷款计提每日逾期本金罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonaccruedovdprinpnltamt is '短期逾期90天以上贷款计提每日逾期本金罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.accruedovdintpnltamt is '短期逾期90天以内(含)贷款计提每日逾期利息罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonaccruedovdintpnltamt is '短期逾期90天以上贷款计提每日逾期利息罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.printoovdprinamt is '正常本金转逾期本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.inttoovdintamt is '正常利息转逾期利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonprintononovdprinamt is '正常本金(非应计)转逾期本金(非应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outinttooutovdintamt is '正常利息(表外)转逾期利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.accruedtononprinamt is '正常本金(应计)转正常本金(非应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.accruedtononovdprinamt is '逾期本金(应计)转逾期本金(非应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.internaltooutintamt is '正常利息(表内)转正常利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.internaltooutovdintamt is '逾期利息(表内)转逾期利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.internaltooutovdprinpnltamt is '逾期本金罚息(表内)转逾期本金罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.internaltooutovdintpnltamt is '逾期利息罚息(表内)转逾期利息罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nontoaccruedprinamt is '正常本金(非应计)转正常本金(应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nontoaccruedovdprinamt is '逾期本金(非应计)转逾期本金(应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outtointernalintamt is '正常利息(表外)转正常利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outtointernalovdintamt is '逾期利息(表外)转逾期利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outtointernalovdprinpnltamt is '逾期本金罚息(表外)转逾本金罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outtointernalovdintpnltamt is '逾期利息罚息(表外)转逾期利息罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidprinamt is '实还正常本金(应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidnonaccruedprinamt is '实还正常本金(非应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidaccruedovdprinamt is '实还逾期本金(应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidnonaccruedovdprinamt is '实还逾期本金(非应计)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidintamt is '实还正常利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidoutintamt is '实还正常利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidinternalovdintamt is '实还逾期利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidoutovdintamt is '实还逾期利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidinternalovdprinpnltintamt is '实还逾期本金罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidoutovdprinpnltintamt is '实还逾期本金罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidinternalovdintpnltintamt is '实还逾期利息罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidoutovdintpnltintamt is '实还逾期利息罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptintamt is '减免正常利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptoutintamt is '减免正常利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptinternalovdintamt is '减免逾期利息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptoutovdintamt is '减免逾期利息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptinternalovdprinpnltintamt is '减免逾期本金罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptoutovdprinpnltintamt is '减免逾期本金罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptinternalovdintpnltintamt is '减免逾期利息罚息(表内)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptoutovdintpnltintamt is '减免逾期利息罚息(表外)';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.printoprinamtrlv is '正常本金转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.ovdprintoprinamtrlv is '逾期本金转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nontoprinamtrlv is '正常本金(非应计)转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonprintoprinamtrlv is '逾期本金(非应计)转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.inttointamtrlv is '正常利息转正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outinttointamtrlv is '正常利息(表外)转正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.ovdinttointamtrlv is '逾期利息(表内)转正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.outovdinttointamtrlv is '逾期利息(表外)转正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffovdprintoprinamtrlv is '逾期本金（核销）转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffovdinttointamtrlv is '逾期利息（核销）转正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.printoprinamtinst is '正常本金转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.ovdprintoprinamtinst is '逾期本金转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonaccruedprinamtinst is '正常本金(非应计)转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonaccruedtoprinamtinst is '逾期本金(非应计)转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffprintoprinamtinst is '正常本金（核销）转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.printoprinmedium is '正常本金转正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.nonprintoprinmedium is '正常本金（非应计）转正常本金（应计）';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.wfprintoprinmedium is '正常本金（核销）转正常本金（应计）';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffnonprinamt is '已减值正常贷款本金核销';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffnonovdprinamt is '已减值逾期贷款本金核销';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffoutintamt is '正常贷款利息（表外）核销';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffoutovdintamt is '逾期贷款利息（表外）核销';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffoutovdprinpnltamt is '逾期本金罚息（表外）核销';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffoutovdintpnltamt is '逾期利息罚息（表外）核销';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffintamt is '已核销的贷款正常利息计提';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffovdprinpnltamt is '已核销的贷款逾期本金罚息计提';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffovdintpnltamt is '已核销的贷款逾期利息罚息计提';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffprintoovdprinamt is '已核销的贷款本金转逾期';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.writeoffinttoovdintamt is '已核销的贷款利息转逾期';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidwriteoffprinamt is '实还已核销正常本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidwriteoffovdprinamt is '实还已核销逾期本金';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidwriteoffintamt is '实还已核销正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidwriteoffovdintamt is '实还已核销逾期利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidwriteoffovdprinpnltintamt is '实还已核销本金罚息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.paidwriteoffovdintpnltintamt is '实还已核销利息罚息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptwriteoffintamt is '减免已核销正常利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptwriteoffovdintamt is '减免已核销逾期利息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptwriteoffovdprinpnltintamt is '减免已核销本金罚息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.exemptwriteoffovdintpnltintamt is '减免已核销利息罚息';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.loantransitdeposit is '放款待结算调拨回流金额';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.repaytransitwithdraw is '还款待结算调拨流入金额';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.loantransitwithdraw is '放款待结算调拨回流金额';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myhb_ac_summary_trans_01.etl_timestamp is 'ETL处理时间戳';
