/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_gl_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_gl_detail
whenever sqlerror continue none;
drop table ${iol_schema}.iers_gl_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_detail(
    accountcode varchar2(60) -- 账簿编号
    ,adjustperiod varchar2(5) -- 调整期间
    ,assid varchar2(30) -- 辅助核算
    ,bankaccount varchar2(30) -- 银行帐户
    ,billtype varchar2(90) -- 票据类型
    ,busireconno varchar2(90) -- 业务系统协同号
    ,checkdate varchar2(29) -- 票据日期
    ,checkno varchar2(45) -- 票据编码
    ,checkstyle varchar2(30) -- 结算方式
    ,contrastflag number(38,0) -- 对账标志
    ,convertflag varchar2(2) -- 是否折算
    ,creditamount number(28,8) -- 原币贷方金额
    ,creditquantity number(20,8) -- 贷方数量
    ,debitamount number(28,8) -- 原币借方金额
    ,debitquantity number(20,8) -- 借方数量
    ,detailindex number(38,0) -- 分录号
    ,direction varchar2(2) -- 发生额方向
    ,discardflagv varchar2(2) -- 作废标志
    ,dr number(10,0) -- 删除标志
    ,errmessage varchar2(135) -- 错误信息
    ,errmessage2 varchar2(90) -- 自定义
    ,errmessageh varchar2(135) -- 标错的历史信息
    ,excrate1 number(15,8) -- 汇率1
    ,excrate2 number(15,8) -- 汇率2
    ,excrate3 number(15,8) -- 集团汇率
    ,excrate4 number(15,8) -- 全局汇率
    ,explanation varchar2(3000) -- 摘要
    ,fraccreditamount number(28,8) -- 辅币贷发生额
    ,fracdebitamount number(28,8) -- 辅币借发生额
    ,free1 varchar2(90) -- 预留字段1
    ,free10 varchar2(90) -- 预留字段10
    ,free2 varchar2(90) -- 预留字段2
    ,free3 varchar2(90) -- 预留字段3
    ,free4 varchar2(90) -- 预留字段4
    ,free5 varchar2(90) -- 预留字段5
    ,free6 varchar2(90) -- 预留字段6
    ,free7 varchar2(90) -- 预留字段7
    ,free8 varchar2(90) -- 预留字段8
    ,free9 varchar2(90) -- 预留字段9
    ,globalcreditamount number(28,8) -- 全局本币贷方金额
    ,globaldebitamount number(28,8) -- 全局本币借方金额
    ,groupcreditamount number(28,8) -- 集团本币贷方金额
    ,groupdebitamount number(28,8) -- 集团本币借方金额
    ,innerbusdate varchar2(29) -- 自定义
    ,innerbusno varchar2(90) -- 自定义
    ,isdifflag varchar2(2) -- 是否差异凭证
    ,localcreditamount number(28,8) -- 组织本币贷方金额
    ,localdebitamount number(28,8) -- 组织本币借方金额
    ,modifyflag varchar2(35) -- 修改标志
    ,netbankflag varchar2(45) -- 网银对账标识码
    ,nov number(38,0) -- 凭证编码
    ,oppositesubj varchar2(300) -- 对方科目
    ,periodv varchar2(3) -- 期间
    ,pk_accasoa varchar2(30) -- 科目
    ,pk_accchart varchar2(30) -- 科目表主键
    ,pk_account varchar2(30) -- 自定义
    ,pk_accountingbook varchar2(30) -- 财务核算账簿
    ,pk_currtype varchar2(30) -- 币种
    ,pk_detail varchar2(30) -- 分录标识
    ,pk_group varchar2(30) -- 所属集团
    ,pk_innerorg varchar2(30) -- 自定义
    ,pk_innersob varchar2(30) -- 自定义
    ,pk_managerv varchar2(30) -- 记账人
    ,pk_offerdetail varchar2(30) -- 被冲销的分录
    ,pk_org varchar2(30) -- 财务组织
    ,pk_org_v varchar2(30) -- 财务组织版本
    ,pk_othercorp varchar2(6) -- 自定义
    ,pk_otherorgbook varchar2(30) -- 自定义
    ,pk_preparedv varchar2(30) -- 自定义
    ,pk_setofbook varchar2(30) -- 账簿类型
    ,pk_sourcepk varchar2(30) -- 折算来源
    ,pk_systemv varchar2(30) -- 制单系统
    ,pk_unit varchar2(30) -- 业务单元
    ,pk_unit_v varchar2(30) -- 业务单元版本
    ,pk_voucher varchar2(30) -- 凭证主键
    ,pk_vouchertypev varchar2(30) -- 凭证类别
    ,prepareddatev varchar2(29) -- 制单日期
    ,price number(28,8) -- 单价
    ,recieptclass varchar2(90) -- 单据处理类
    ,signdatev varchar2(29) -- 签字日期
    ,tempsaveflag varchar2(2) -- 自定义
    ,ts varchar2(29) -- 时间戳
    ,unitname varchar2(300) -- 业务单元名称
    ,verifydate varchar2(29) -- 核销日期
    ,verifyno varchar2(90) -- 核销号
    ,voucherkindv number(38,0) -- 凭证类型
    ,yearv varchar2(6) -- 年度
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
grant select on ${iol_schema}.iers_gl_detail to ${iml_schema};
grant select on ${iol_schema}.iers_gl_detail to ${icl_schema};
grant select on ${iol_schema}.iers_gl_detail to ${idl_schema};
grant select on ${iol_schema}.iers_gl_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_gl_detail is '新费用凭证明细';
comment on column ${iol_schema}.iers_gl_detail.accountcode is '账簿编号';
comment on column ${iol_schema}.iers_gl_detail.adjustperiod is '调整期间';
comment on column ${iol_schema}.iers_gl_detail.assid is '辅助核算';
comment on column ${iol_schema}.iers_gl_detail.bankaccount is '银行帐户';
comment on column ${iol_schema}.iers_gl_detail.billtype is '票据类型';
comment on column ${iol_schema}.iers_gl_detail.busireconno is '业务系统协同号';
comment on column ${iol_schema}.iers_gl_detail.checkdate is '票据日期';
comment on column ${iol_schema}.iers_gl_detail.checkno is '票据编码';
comment on column ${iol_schema}.iers_gl_detail.checkstyle is '结算方式';
comment on column ${iol_schema}.iers_gl_detail.contrastflag is '对账标志';
comment on column ${iol_schema}.iers_gl_detail.convertflag is '是否折算';
comment on column ${iol_schema}.iers_gl_detail.creditamount is '原币贷方金额';
comment on column ${iol_schema}.iers_gl_detail.creditquantity is '贷方数量';
comment on column ${iol_schema}.iers_gl_detail.debitamount is '原币借方金额';
comment on column ${iol_schema}.iers_gl_detail.debitquantity is '借方数量';
comment on column ${iol_schema}.iers_gl_detail.detailindex is '分录号';
comment on column ${iol_schema}.iers_gl_detail.direction is '发生额方向';
comment on column ${iol_schema}.iers_gl_detail.discardflagv is '作废标志';
comment on column ${iol_schema}.iers_gl_detail.dr is '删除标志';
comment on column ${iol_schema}.iers_gl_detail.errmessage is '错误信息';
comment on column ${iol_schema}.iers_gl_detail.errmessage2 is '自定义';
comment on column ${iol_schema}.iers_gl_detail.errmessageh is '标错的历史信息';
comment on column ${iol_schema}.iers_gl_detail.excrate1 is '汇率1';
comment on column ${iol_schema}.iers_gl_detail.excrate2 is '汇率2';
comment on column ${iol_schema}.iers_gl_detail.excrate3 is '集团汇率';
comment on column ${iol_schema}.iers_gl_detail.excrate4 is '全局汇率';
comment on column ${iol_schema}.iers_gl_detail.explanation is '摘要';
comment on column ${iol_schema}.iers_gl_detail.fraccreditamount is '辅币贷发生额';
comment on column ${iol_schema}.iers_gl_detail.fracdebitamount is '辅币借发生额';
comment on column ${iol_schema}.iers_gl_detail.free1 is '预留字段1';
comment on column ${iol_schema}.iers_gl_detail.free10 is '预留字段10';
comment on column ${iol_schema}.iers_gl_detail.free2 is '预留字段2';
comment on column ${iol_schema}.iers_gl_detail.free3 is '预留字段3';
comment on column ${iol_schema}.iers_gl_detail.free4 is '预留字段4';
comment on column ${iol_schema}.iers_gl_detail.free5 is '预留字段5';
comment on column ${iol_schema}.iers_gl_detail.free6 is '预留字段6';
comment on column ${iol_schema}.iers_gl_detail.free7 is '预留字段7';
comment on column ${iol_schema}.iers_gl_detail.free8 is '预留字段8';
comment on column ${iol_schema}.iers_gl_detail.free9 is '预留字段9';
comment on column ${iol_schema}.iers_gl_detail.globalcreditamount is '全局本币贷方金额';
comment on column ${iol_schema}.iers_gl_detail.globaldebitamount is '全局本币借方金额';
comment on column ${iol_schema}.iers_gl_detail.groupcreditamount is '集团本币贷方金额';
comment on column ${iol_schema}.iers_gl_detail.groupdebitamount is '集团本币借方金额';
comment on column ${iol_schema}.iers_gl_detail.innerbusdate is '自定义';
comment on column ${iol_schema}.iers_gl_detail.innerbusno is '自定义';
comment on column ${iol_schema}.iers_gl_detail.isdifflag is '是否差异凭证';
comment on column ${iol_schema}.iers_gl_detail.localcreditamount is '组织本币贷方金额';
comment on column ${iol_schema}.iers_gl_detail.localdebitamount is '组织本币借方金额';
comment on column ${iol_schema}.iers_gl_detail.modifyflag is '修改标志';
comment on column ${iol_schema}.iers_gl_detail.netbankflag is '网银对账标识码';
comment on column ${iol_schema}.iers_gl_detail.nov is '凭证编码';
comment on column ${iol_schema}.iers_gl_detail.oppositesubj is '对方科目';
comment on column ${iol_schema}.iers_gl_detail.periodv is '期间';
comment on column ${iol_schema}.iers_gl_detail.pk_accasoa is '科目';
comment on column ${iol_schema}.iers_gl_detail.pk_accchart is '科目表主键';
comment on column ${iol_schema}.iers_gl_detail.pk_account is '自定义';
comment on column ${iol_schema}.iers_gl_detail.pk_accountingbook is '财务核算账簿';
comment on column ${iol_schema}.iers_gl_detail.pk_currtype is '币种';
comment on column ${iol_schema}.iers_gl_detail.pk_detail is '分录标识';
comment on column ${iol_schema}.iers_gl_detail.pk_group is '所属集团';
comment on column ${iol_schema}.iers_gl_detail.pk_innerorg is '自定义';
comment on column ${iol_schema}.iers_gl_detail.pk_innersob is '自定义';
comment on column ${iol_schema}.iers_gl_detail.pk_managerv is '记账人';
comment on column ${iol_schema}.iers_gl_detail.pk_offerdetail is '被冲销的分录';
comment on column ${iol_schema}.iers_gl_detail.pk_org is '财务组织';
comment on column ${iol_schema}.iers_gl_detail.pk_org_v is '财务组织版本';
comment on column ${iol_schema}.iers_gl_detail.pk_othercorp is '自定义';
comment on column ${iol_schema}.iers_gl_detail.pk_otherorgbook is '自定义';
comment on column ${iol_schema}.iers_gl_detail.pk_preparedv is '自定义';
comment on column ${iol_schema}.iers_gl_detail.pk_setofbook is '账簿类型';
comment on column ${iol_schema}.iers_gl_detail.pk_sourcepk is '折算来源';
comment on column ${iol_schema}.iers_gl_detail.pk_systemv is '制单系统';
comment on column ${iol_schema}.iers_gl_detail.pk_unit is '业务单元';
comment on column ${iol_schema}.iers_gl_detail.pk_unit_v is '业务单元版本';
comment on column ${iol_schema}.iers_gl_detail.pk_voucher is '凭证主键';
comment on column ${iol_schema}.iers_gl_detail.pk_vouchertypev is '凭证类别';
comment on column ${iol_schema}.iers_gl_detail.prepareddatev is '制单日期';
comment on column ${iol_schema}.iers_gl_detail.price is '单价';
comment on column ${iol_schema}.iers_gl_detail.recieptclass is '单据处理类';
comment on column ${iol_schema}.iers_gl_detail.signdatev is '签字日期';
comment on column ${iol_schema}.iers_gl_detail.tempsaveflag is '自定义';
comment on column ${iol_schema}.iers_gl_detail.ts is '时间戳';
comment on column ${iol_schema}.iers_gl_detail.unitname is '业务单元名称';
comment on column ${iol_schema}.iers_gl_detail.verifydate is '核销日期';
comment on column ${iol_schema}.iers_gl_detail.verifyno is '核销号';
comment on column ${iol_schema}.iers_gl_detail.voucherkindv is '凭证类型';
comment on column ${iol_schema}.iers_gl_detail.yearv is '年度';
comment on column ${iol_schema}.iers_gl_detail.start_dt is '开始时间';
comment on column ${iol_schema}.iers_gl_detail.end_dt is '结束时间';
comment on column ${iol_schema}.iers_gl_detail.id_mark is '增删标志';
comment on column ${iol_schema}.iers_gl_detail.etl_timestamp is 'ETL处理时间戳';
