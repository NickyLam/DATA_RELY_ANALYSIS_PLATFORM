/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_resell_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_resell_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_resell_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_resell_duebill(
    serialno varchar2(32) -- 申请流水号
    ,reselltype varchar2(2) -- 01境内转让、02行内转让、03跨境转让
    ,businesscurrency varchar2(32) -- 币种
    ,balance number(24,6) -- 借据余额
    ,businesstype varchar2(20) -- 业务品种
    ,openbankname varchar2(200) -- 开证行
    ,inputdate date -- 申请时间
    ,transferflag varchar2(10) -- 转让标识字段(SUCCESS已转让)
    ,repayaccountno varchar2(20) -- 还款账号
    ,transferdate date -- 转让时间
    ,businesssum number(24,6) -- 借据金额
    ,duebillno varchar2(40) -- 借据号
    ,tempsaveflag varchar2(1) -- 暂存标志
    ,repayment number(24,6) -- 还款金额
    ,buybankname varchar2(200) -- 包买行
    ,putoutno varchar2(40) -- 核心出账流水号
    ,importcharges number(24,6) -- 汇入手续费支出
    ,masterserialno varchar2(32) -- 主表流水号
    ,updatedate date -- 更新时间
    ,salematurity date -- 转卖到期日
    ,remnan number(24,6) -- 待摊金额(剩余利息摊销金额)
    ,inputuserid varchar2(8) -- 申请人
    ,updateuserid varchar2(8) -- 更新人
    ,customername varchar2(80) -- 客户名
    ,bankhavesum number(24,6) -- 我行持有期间利息
    ,saleminsum number(24,6) -- 转出机构转让中间业务损益
    ,saleratio varchar2(20) -- 卖出利率
    ,updateorgid varchar2(12) -- 更新机构
    ,migtflag varchar2(80) -- 
    ,customerid varchar2(32) -- 客户号
    ,insaleminsum number(24,6) -- 转入机构转让中间业务损益
    ,putoutserialno varchar2(40) -- 出账表出账流水号
    ,boughtsum number(24,6) -- 转卖收款金额
    ,inputorgid varchar2(32) -- 申请机构
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
grant select on ${iol_schema}.icms_resell_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_resell_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_resell_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_resell_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_resell_duebill is '同业间福费廷资产转让申请明细';
comment on column ${iol_schema}.icms_resell_duebill.serialno is '申请流水号';
comment on column ${iol_schema}.icms_resell_duebill.reselltype is '01境内转让、02行内转让、03跨境转让';
comment on column ${iol_schema}.icms_resell_duebill.businesscurrency is '币种';
comment on column ${iol_schema}.icms_resell_duebill.balance is '借据余额';
comment on column ${iol_schema}.icms_resell_duebill.businesstype is '业务品种';
comment on column ${iol_schema}.icms_resell_duebill.openbankname is '开证行';
comment on column ${iol_schema}.icms_resell_duebill.inputdate is '申请时间';
comment on column ${iol_schema}.icms_resell_duebill.transferflag is '转让标识字段(SUCCESS已转让)';
comment on column ${iol_schema}.icms_resell_duebill.repayaccountno is '还款账号';
comment on column ${iol_schema}.icms_resell_duebill.transferdate is '转让时间';
comment on column ${iol_schema}.icms_resell_duebill.businesssum is '借据金额';
comment on column ${iol_schema}.icms_resell_duebill.duebillno is '借据号';
comment on column ${iol_schema}.icms_resell_duebill.tempsaveflag is '暂存标志';
comment on column ${iol_schema}.icms_resell_duebill.repayment is '还款金额';
comment on column ${iol_schema}.icms_resell_duebill.buybankname is '包买行';
comment on column ${iol_schema}.icms_resell_duebill.putoutno is '核心出账流水号';
comment on column ${iol_schema}.icms_resell_duebill.importcharges is '汇入手续费支出';
comment on column ${iol_schema}.icms_resell_duebill.masterserialno is '主表流水号';
comment on column ${iol_schema}.icms_resell_duebill.updatedate is '更新时间';
comment on column ${iol_schema}.icms_resell_duebill.salematurity is '转卖到期日';
comment on column ${iol_schema}.icms_resell_duebill.remnan is '待摊金额(剩余利息摊销金额)';
comment on column ${iol_schema}.icms_resell_duebill.inputuserid is '申请人';
comment on column ${iol_schema}.icms_resell_duebill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_resell_duebill.customername is '客户名';
comment on column ${iol_schema}.icms_resell_duebill.bankhavesum is '我行持有期间利息';
comment on column ${iol_schema}.icms_resell_duebill.saleminsum is '转出机构转让中间业务损益';
comment on column ${iol_schema}.icms_resell_duebill.saleratio is '卖出利率';
comment on column ${iol_schema}.icms_resell_duebill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_resell_duebill.migtflag is '';
comment on column ${iol_schema}.icms_resell_duebill.customerid is '客户号';
comment on column ${iol_schema}.icms_resell_duebill.insaleminsum is '转入机构转让中间业务损益';
comment on column ${iol_schema}.icms_resell_duebill.putoutserialno is '出账表出账流水号';
comment on column ${iol_schema}.icms_resell_duebill.boughtsum is '转卖收款金额';
comment on column ${iol_schema}.icms_resell_duebill.inputorgid is '申请机构';
comment on column ${iol_schema}.icms_resell_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_resell_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_resell_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_resell_duebill.etl_timestamp is 'ETL处理时间戳';
