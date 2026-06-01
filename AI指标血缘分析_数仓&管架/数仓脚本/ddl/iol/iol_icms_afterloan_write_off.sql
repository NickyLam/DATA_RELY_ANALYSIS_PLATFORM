/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_write_off
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_write_off
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_write_off purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_write_off(
    serialno varchar2(40) -- 业务流水号
    ,cancelrecein number(24,6) -- 核销表内利息
    ,claimsrecoverygrt varchar2(4000) -- 保证人、抵押/质押物追偿情况及结果
    ,claimsrecoveryborrower varchar2(4000) -- 借款人（或股权）追偿情况及结果
    ,customerid varchar2(30) -- 客户号
    ,cussex varchar2(1) -- 性别
    ,borrowercriminalnumber varchar2(100) -- 借款人被判触犯刑律文号
    ,courtfinarulingtime date -- 法院最终裁定时间
    ,dzhxbatchno varchar2(60) -- 呆账核销批次号
    ,batsubtype varchar2(5) -- 业务子类
    ,loanbalance number(24,6) -- 贷款余额
    ,amt number(24,6) -- 本金
    ,customername varchar2(200) -- 客户名称
    ,borrowercriminaltime varchar2(10) -- 借款人被判触犯刑律时间
    ,otherprooftime varchar2(10) -- 其他形式证明时间
    ,approveverificationperiod varchar2(10) -- 审批核销日期
    ,courtfinarulingtitle varchar2(100) -- 法院最终裁定文件名
    ,inputuserid varchar2(20) -- 登记人
    ,cancelcurtype varchar2(3) -- 核销金额币种
    ,baddebtscausereason varchar2(4000) -- 呆账形成原因
    ,inputdate date -- 登记日期
    ,certid varchar2(60) -- 证件号码
    ,canceltype varchar2(3) -- 核销类别
    ,responsibilityidentifyresult varchar2(4000) -- 责任认定及责任认定处理结果
    ,curtype varchar2(3) -- 币种
    ,approvehxininterest number(22,4) -- 审批核销表内利息
    ,inputorgid varchar2(20) -- 登记机构
    ,courtfinarulingnumber varchar2(100) -- 法院最终裁定文号
    ,cancelamount number(24,6) -- 核销本金
    ,otherprooftitle varchar2(100) -- 其他形式证明文件名
    ,approvedate date -- 核销日期
    ,finabrid varchar2(20) -- 账务机构
    ,certtype varchar2(4) -- 证件类型
    ,approveamt number(22,2) -- 核销金额
    ,approvehxoutinterest number(22,4) -- 审批核销表外利息
    ,accids varchar2(4000) -- 借据编号集合
    ,cusmarst varchar2(2) -- 婚姻状况
    ,approvestatus varchar2(64) -- 审批状态
    ,borrowerbusicodecanceltime varchar2(10) -- 工商部门注销（或吊销）借款人营业执照时间
    ,uplproductid varchar2(20) -- 微贷业务品种
    ,compname varchar2(60) -- 经营企业名称
    ,isretainrecourse varchar2(1) -- 是否保留对债务人的追索权
    ,cancelreceout number(24,6) -- 核销表外利息
    ,borrowercriminaltitle varchar2(100) -- 借款人被判触犯刑律文件名
    ,advancepayment number(24,6) -- 垫付费用
    ,otherproofnumber varchar2(100) -- 其他形式证明文号
    ,industry varchar2(20) -- 所属行业
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,exposureamount number(24,6) -- 敞口金额
    ,advancepatotal number(24,6) -- 总垫付金额
    ,completeflag varchar2(2) -- 数据录入完整性标识
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
grant select on ${iol_schema}.icms_afterloan_write_off to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_write_off to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_write_off to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_write_off to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_write_off is '贷后核销申请';
comment on column ${iol_schema}.icms_afterloan_write_off.serialno is '业务流水号';
comment on column ${iol_schema}.icms_afterloan_write_off.cancelrecein is '核销表内利息';
comment on column ${iol_schema}.icms_afterloan_write_off.claimsrecoverygrt is '保证人、抵押/质押物追偿情况及结果';
comment on column ${iol_schema}.icms_afterloan_write_off.claimsrecoveryborrower is '借款人（或股权）追偿情况及结果';
comment on column ${iol_schema}.icms_afterloan_write_off.customerid is '客户号';
comment on column ${iol_schema}.icms_afterloan_write_off.cussex is '性别';
comment on column ${iol_schema}.icms_afterloan_write_off.borrowercriminalnumber is '借款人被判触犯刑律文号';
comment on column ${iol_schema}.icms_afterloan_write_off.courtfinarulingtime is '法院最终裁定时间';
comment on column ${iol_schema}.icms_afterloan_write_off.dzhxbatchno is '呆账核销批次号';
comment on column ${iol_schema}.icms_afterloan_write_off.batsubtype is '业务子类';
comment on column ${iol_schema}.icms_afterloan_write_off.loanbalance is '贷款余额';
comment on column ${iol_schema}.icms_afterloan_write_off.amt is '本金';
comment on column ${iol_schema}.icms_afterloan_write_off.customername is '客户名称';
comment on column ${iol_schema}.icms_afterloan_write_off.borrowercriminaltime is '借款人被判触犯刑律时间';
comment on column ${iol_schema}.icms_afterloan_write_off.otherprooftime is '其他形式证明时间';
comment on column ${iol_schema}.icms_afterloan_write_off.approveverificationperiod is '审批核销日期';
comment on column ${iol_schema}.icms_afterloan_write_off.courtfinarulingtitle is '法院最终裁定文件名';
comment on column ${iol_schema}.icms_afterloan_write_off.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_write_off.cancelcurtype is '核销金额币种';
comment on column ${iol_schema}.icms_afterloan_write_off.baddebtscausereason is '呆账形成原因';
comment on column ${iol_schema}.icms_afterloan_write_off.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_write_off.certid is '证件号码';
comment on column ${iol_schema}.icms_afterloan_write_off.canceltype is '核销类别';
comment on column ${iol_schema}.icms_afterloan_write_off.responsibilityidentifyresult is '责任认定及责任认定处理结果';
comment on column ${iol_schema}.icms_afterloan_write_off.curtype is '币种';
comment on column ${iol_schema}.icms_afterloan_write_off.approvehxininterest is '审批核销表内利息';
comment on column ${iol_schema}.icms_afterloan_write_off.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_write_off.courtfinarulingnumber is '法院最终裁定文号';
comment on column ${iol_schema}.icms_afterloan_write_off.cancelamount is '核销本金';
comment on column ${iol_schema}.icms_afterloan_write_off.otherprooftitle is '其他形式证明文件名';
comment on column ${iol_schema}.icms_afterloan_write_off.approvedate is '核销日期';
comment on column ${iol_schema}.icms_afterloan_write_off.finabrid is '账务机构';
comment on column ${iol_schema}.icms_afterloan_write_off.certtype is '证件类型';
comment on column ${iol_schema}.icms_afterloan_write_off.approveamt is '核销金额';
comment on column ${iol_schema}.icms_afterloan_write_off.approvehxoutinterest is '审批核销表外利息';
comment on column ${iol_schema}.icms_afterloan_write_off.accids is '借据编号集合';
comment on column ${iol_schema}.icms_afterloan_write_off.cusmarst is '婚姻状况';
comment on column ${iol_schema}.icms_afterloan_write_off.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_afterloan_write_off.borrowerbusicodecanceltime is '工商部门注销（或吊销）借款人营业执照时间';
comment on column ${iol_schema}.icms_afterloan_write_off.uplproductid is '微贷业务品种';
comment on column ${iol_schema}.icms_afterloan_write_off.compname is '经营企业名称';
comment on column ${iol_schema}.icms_afterloan_write_off.isretainrecourse is '是否保留对债务人的追索权';
comment on column ${iol_schema}.icms_afterloan_write_off.cancelreceout is '核销表外利息';
comment on column ${iol_schema}.icms_afterloan_write_off.borrowercriminaltitle is '借款人被判触犯刑律文件名';
comment on column ${iol_schema}.icms_afterloan_write_off.advancepayment is '垫付费用';
comment on column ${iol_schema}.icms_afterloan_write_off.otherproofnumber is '其他形式证明文号';
comment on column ${iol_schema}.icms_afterloan_write_off.industry is '所属行业';
comment on column ${iol_schema}.icms_afterloan_write_off.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_afterloan_write_off.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_afterloan_write_off.advancepatotal is '总垫付金额';
comment on column ${iol_schema}.icms_afterloan_write_off.completeflag is '数据录入完整性标识';
comment on column ${iol_schema}.icms_afterloan_write_off.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_write_off.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_write_off.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_write_off.etl_timestamp is 'ETL处理时间戳';
