/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_write_off_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_write_off_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_write_off_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_write_off_duebill(
    bdserialno varchar2(64) -- 借据编号
    ,overduedays number(22) -- 逾期天数
    ,certtype varchar2(36) -- 证件类型
    ,actlwriteoffinint number(24,6) -- 核销表内利息
    ,collectionnum number(22) -- 催收次数
    ,writeoffdate date -- 指该贷款首次的核销日期。
    ,capitalpenaltybalance number(24,6) -- 罚息
    ,filepath varchar2(256) -- 文件路径
    ,inboundbatno varchar2(64) -- 入库批次号
    ,enddate date -- 贷款逾期日
    ,actlwriteoffoffint number(24,6) -- 指银行贷款核销时应收回表外利息
    ,advancepayment number(24,6) -- 核销垫付费用
    ,certid varchar2(60) -- 证件号码
    ,executerate number(15,8) -- 执行年利率
    ,termmonth number(22) -- 期限
    ,startdate date -- 贷款发放日
    ,loanbalance number(24,6) -- 存款余额
    ,inbounddate date -- 入库日期
    ,customerid varchar2(16) -- 客户编号
    ,finabrid varchar2(10) -- 账务机构
    ,customername varchar2(200) -- 客户名称
    ,maturity date -- 借据到期日
    ,overdueinterest number(24,6) -- 利息
    ,writeoffstatus varchar2(10) -- 核销状态
    ,remark varchar2(256) -- 备注
    ,sex varchar2(2) -- 性别
    ,balance number(24,6) -- 借据余额
    ,billtype varchar2(10) -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,businesssum number(24,6) -- 借据金额
    ,repaytype varchar2(36) -- 还款方式
    ,loansum number(24,6) -- 贷款余额
    ,businesstype varchar2(10) -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
    ,actlwriteoffloanprcp number(24,6) -- 指银行贷款核销时应收回本金
    ,fiveriskcla varchar2(10) -- 五级风险分类
    ,updatedate date -- 
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
grant select on ${iol_schema}.icms_afterloan_write_off_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_write_off_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_write_off_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_write_off_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_write_off_duebill is '贷后核销借据信息';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.bdserialno is '借据编号';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.certtype is '证件类型';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.actlwriteoffinint is '核销表内利息';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.collectionnum is '催收次数';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.writeoffdate is '指该贷款首次的核销日期。';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.capitalpenaltybalance is '罚息';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.filepath is '文件路径';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.inboundbatno is '入库批次号';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.enddate is '贷款逾期日';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.actlwriteoffoffint is '指银行贷款核销时应收回表外利息';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.advancepayment is '核销垫付费用';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.certid is '证件号码';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.executerate is '执行年利率';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.termmonth is '期限';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.startdate is '贷款发放日';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.loanbalance is '存款余额';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.inbounddate is '入库日期';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.customerid is '客户编号';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.finabrid is '账务机构';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.customername is '客户名称';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.maturity is '借据到期日';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.overdueinterest is '利息';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.writeoffstatus is '核销状态';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.remark is '备注';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.sex is '性别';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.balance is '借据余额';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.billtype is '借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.businesssum is '借据金额';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.repaytype is '还款方式';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.loansum is '贷款余额';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.businesstype is '业务类型:1借呗二期2借呗三期3花呗4网商贷';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.actlwriteoffloanprcp is '指银行贷款核销时应收回本金';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.fiveriskcla is '五级风险分类';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.updatedate is '';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_write_off_duebill.etl_timestamp is 'ETL处理时间戳';
