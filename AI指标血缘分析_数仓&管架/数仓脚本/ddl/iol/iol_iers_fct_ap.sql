/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fct_ap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fct_ap
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fct_ap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fct_ap(
    actualinvalidate varchar2(29) -- 实际终止日期
    ,actualvalidate varchar2(29) -- 实际生效日期
    ,approver varchar2(30) -- 审批人
    ,bankaccount varchar2(30) -- 对方银行账号
    ,billmaker varchar2(30) -- 制单人
    ,blatest varchar2(2) -- 是否最新版本
    ,bordernumexec varchar2(2) -- 已生成订单量作为合同执行
    ,btriatradeflag varchar2(2) -- 三角贸易
    ,cbilltypecode varchar2(30) -- 单据类型
    ,ccurrencyid varchar2(30) -- 本位币
    ,corigcurrencyid varchar2(30) -- 币种
    ,cprojectid varchar2(30) -- 项目
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,crececountryid varchar2(30) -- 收货国家/地区
    ,csendcountryid varchar2(30) -- 发货国家/地区
    ,ctaxcountryid varchar2(30) -- 报税货国家/地区
    ,ctname varchar2(3000) -- 合同名称
    ,ctname2 varchar2(90) -- 合同名称2
    ,ctname3 varchar2(90) -- 合同名称3
    ,ctname4 varchar2(90) -- 合同名称4
    ,ctname5 varchar2(90) -- 合同名称5
    ,ctname6 varchar2(90) -- 合同名称6
    ,ctrantypeid varchar2(30) -- 合同类型
    ,custunit varchar2(45) -- 对方单位说明
    ,cvendorid varchar2(30) -- 供应商
    ,dbilldate varchar2(29) -- 单据日期
    ,deliaddr varchar2(30) -- 交货地点
    ,depid varchar2(30) -- 承办部门
    ,depid_v varchar2(30) -- 承办部门版本
    ,dmakedate varchar2(29) -- 制单日期
    ,dr number(10,0) -- 删除标志
    ,earlysign varchar2(2) -- 期初标志
    ,fbuysellflag number(22,0) -- 购销类型
    ,fstatusflag number(22,0) -- 合同状态
    ,invallidate varchar2(29) -- 计划终止日期
    ,iprintcount number(22,0) -- 打印次数
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,mountcalculation number(22,0) -- 计划金额计算方式
    ,nexchangerate number(28,8) -- 折本汇率
    ,nglobalexchgrate number(28,8) -- 全局本位币汇率
    ,ngroupexchgrate number(28,8) -- 集团本位币汇率
    ,norigcopamount number(28,8) -- 累计原币应付金额
    ,norigplanamount number(28,8) -- 累计原币预付款金额
    ,norigpshamount number(28,8) -- 累计原币付款金额
    ,norikpmny number(28,8) -- 累计原币收票金额
    ,noriprepaylimitmny number(28,8) -- 预付款限额
    ,noriprepaymny number(28,8) -- 预付款
    ,nprepaylimitmny number(28,8) -- 本币预付款限额
    ,nprepaymny number(28,8) -- 本币预付款
    ,ntotalastnum number(28,8) -- 总数量
    ,ntotalcopamount number(28,8) -- 累计本币应付金额
    ,ntotalgpamount number(28,8) -- 累计本币付款金额
    ,ntotalorigmny number(28,8) -- 原币价税合计
    ,ntotalplanamount number(28,8) -- 累计本币预付款金额
    ,ntotaltaxmny number(28,8) -- 本币价税合计
    ,openct varchar2(2) -- 是否敞口合同
    ,organizer varchar2(30) -- 承办组织
    ,organizer_v varchar2(30) -- 承办组织版本
    ,ourbankaccount varchar2(30) -- 本方银行账号
    ,oursignatory varchar2(30) -- 本方签字人
    ,overrate number(28,8) -- 超合同付款比例
    ,personnelid varchar2(30) -- 承办人员
    ,pk_fct_ap varchar2(30) -- 付款合同主键
    ,pk_group varchar2(30) -- 集团
    ,pk_org varchar2(30) -- 财务组织
    ,pk_org_v varchar2(30) -- 财务组织版本
    ,pk_origct varchar2(30) -- 原始主键
    ,pk_payterm varchar2(30) -- 付款协议
    ,saga_btxid varchar2(96) -- 
    ,saga_frozen number(38,0) -- 
    ,saga_gtxid varchar2(96) -- 
    ,saga_status number(38,0) -- 
    ,signatory varchar2(30) -- 对方签字人
    ,signorg varchar2(30) -- 签约组织
    ,signorg_v varchar2(30) -- 签约组织版本
    ,subscribedate varchar2(29) -- 签字盖章日期
    ,taudittime varchar2(29) -- 审批日期
    ,taxpayernumber varchar2(30) -- 对方纳税人识别号
    ,ts varchar2(29) -- 时间戳
    ,unconfpayableorg number(28,8) -- 未确认本币应付金额
    ,unconfpayableori number(28,8) -- 未确认原币应付金额
    ,unconfpaymentorg number(28,8) -- 未确认本币付款金额
    ,unconfpaymentori number(28,8) -- 未确认原币付款金额
    ,valdate varchar2(29) -- 计划生效日期
    ,vbillcode varchar2(60) -- 合同编码
    ,vdef1 varchar2(152) -- 自定义项1
    ,vdef10 varchar2(152) -- 自定义项10
    ,vdef11 varchar2(152) -- 自定义项11
    ,vdef12 varchar2(152) -- 自定义项12
    ,vdef13 varchar2(152) -- 自定义项13
    ,vdef14 varchar2(152) -- 自定义项14
    ,vdef15 varchar2(152) -- 自定义项15
    ,vdef16 varchar2(152) -- 自定义项16
    ,vdef17 varchar2(152) -- 自定义项17
    ,vdef18 varchar2(152) -- 自定义项18
    ,vdef19 varchar2(152) -- 自定义项19
    ,vdef2 varchar2(152) -- 自定义项2
    ,vdef20 varchar2(152) -- 自定义项20
    ,vdef21 varchar2(152) -- 自定义项21
    ,vdef22 varchar2(152) -- 自定义项22
    ,vdef23 varchar2(152) -- 自定义项23
    ,vdef24 varchar2(152) -- 自定义项24
    ,vdef25 varchar2(152) -- 自定义项25
    ,vdef26 varchar2(152) -- 自定义项26
    ,vdef27 varchar2(152) -- 自定义项27
    ,vdef28 varchar2(152) -- 自定义项28
    ,vdef29 varchar2(152) -- 自定义项29
    ,vdef3 varchar2(152) -- 自定义项3
    ,vdef30 varchar2(152) -- 自定义项30
    ,vdef31 varchar2(152) -- 自定义项31
    ,vdef32 varchar2(152) -- 自定义项32
    ,vdef33 varchar2(152) -- 自定义项33
    ,vdef34 varchar2(152) -- 自定义项34
    ,vdef35 varchar2(152) -- 自定义项35
    ,vdef36 varchar2(152) -- 自定义项36
    ,vdef37 varchar2(152) -- 自定义项37
    ,vdef38 varchar2(152) -- 自定义项38
    ,vdef39 varchar2(152) -- 自定义项39
    ,vdef4 varchar2(152) -- 自定义项4
    ,vdef40 varchar2(750) -- 自定义项40
    ,vdef41 varchar2(152) -- 自定义项41
    ,vdef42 varchar2(152) -- 自定义项42
    ,vdef43 varchar2(152) -- 自定义项43
    ,vdef44 varchar2(152) -- 自定义项44
    ,vdef45 varchar2(152) -- 自定义项45
    ,vdef46 varchar2(152) -- 自定义项46
    ,vdef47 varchar2(152) -- 自定义项47
    ,vdef48 varchar2(152) -- 自定义项48
    ,vdef49 varchar2(152) -- 自定义项49
    ,vdef5 varchar2(1500) -- 自定义项5
    ,vdef50 varchar2(152) -- 自定义项50
    ,vdef51 varchar2(152) -- 自定义项51
    ,vdef52 varchar2(152) -- 自定义项52
    ,vdef53 varchar2(152) -- 自定义项53
    ,vdef54 varchar2(152) -- 自定义项54
    ,vdef55 varchar2(152) -- 自定义项55
    ,vdef56 varchar2(152) -- 自定义项56
    ,vdef57 varchar2(152) -- 自定义项57
    ,vdef58 varchar2(152) -- 自定义项58
    ,vdef59 varchar2(152) -- 自定义项59
    ,vdef6 varchar2(152) -- 自定义项6
    ,vdef60 varchar2(152) -- 自定义项60
    ,vdef61 varchar2(152) -- 自定义项61
    ,vdef62 varchar2(152) -- 自定义项62
    ,vdef63 varchar2(152) -- 自定义项63
    ,vdef64 varchar2(152) -- 自定义项64
    ,vdef65 varchar2(152) -- 自定义项65
    ,vdef66 varchar2(152) -- 自定义项66
    ,vdef67 varchar2(152) -- 自定义项67
    ,vdef68 varchar2(152) -- 自定义项68
    ,vdef69 varchar2(152) -- 自定义项69
    ,vdef7 varchar2(152) -- 自定义项7
    ,vdef70 varchar2(152) -- 自定义项70
    ,vdef71 varchar2(152) -- 自定义项71
    ,vdef72 varchar2(152) -- 自定义项72
    ,vdef73 varchar2(152) -- 自定义项73
    ,vdef74 varchar2(152) -- 自定义项74
    ,vdef75 varchar2(152) -- 自定义项75
    ,vdef76 varchar2(152) -- 自定义项76
    ,vdef77 varchar2(152) -- 自定义项77
    ,vdef78 varchar2(152) -- 自定义项78
    ,vdef79 varchar2(152) -- 自定义项79
    ,vdef8 varchar2(152) -- 自定义项8
    ,vdef80 varchar2(152) -- 自定义项80
    ,vdef81 varchar2(152) -- 自定义项81
    ,vdef82 varchar2(152) -- 自定义项82
    ,vdef83 varchar2(152) -- 自定义项83
    ,vdef84 varchar2(152) -- 自定义项84
    ,vdef85 varchar2(152) -- 自定义项85
    ,vdef86 varchar2(152) -- 自定义项86
    ,vdef87 varchar2(152) -- 自定义项87
    ,vdef88 varchar2(152) -- 自定义项88
    ,vdef89 varchar2(152) -- 自定义项89
    ,vdef9 varchar2(152) -- 自定义项9
    ,vdef90 varchar2(152) -- 自定义项90
    ,version number(28,0) -- 版本号
    ,vtrantypecode varchar2(30) -- 合同类型编码
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
grant select on ${iol_schema}.iers_fct_ap to ${iml_schema};
grant select on ${iol_schema}.iers_fct_ap to ${icl_schema};
grant select on ${iol_schema}.iers_fct_ap to ${idl_schema};
grant select on ${iol_schema}.iers_fct_ap to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fct_ap is '付款合同表';
comment on column ${iol_schema}.iers_fct_ap.actualinvalidate is '实际终止日期';
comment on column ${iol_schema}.iers_fct_ap.actualvalidate is '实际生效日期';
comment on column ${iol_schema}.iers_fct_ap.approver is '审批人';
comment on column ${iol_schema}.iers_fct_ap.bankaccount is '对方银行账号';
comment on column ${iol_schema}.iers_fct_ap.billmaker is '制单人';
comment on column ${iol_schema}.iers_fct_ap.blatest is '是否最新版本';
comment on column ${iol_schema}.iers_fct_ap.bordernumexec is '已生成订单量作为合同执行';
comment on column ${iol_schema}.iers_fct_ap.btriatradeflag is '三角贸易';
comment on column ${iol_schema}.iers_fct_ap.cbilltypecode is '单据类型';
comment on column ${iol_schema}.iers_fct_ap.ccurrencyid is '本位币';
comment on column ${iol_schema}.iers_fct_ap.corigcurrencyid is '币种';
comment on column ${iol_schema}.iers_fct_ap.cprojectid is '项目';
comment on column ${iol_schema}.iers_fct_ap.creationtime is '创建时间';
comment on column ${iol_schema}.iers_fct_ap.creator is '创建人';
comment on column ${iol_schema}.iers_fct_ap.crececountryid is '收货国家/地区';
comment on column ${iol_schema}.iers_fct_ap.csendcountryid is '发货国家/地区';
comment on column ${iol_schema}.iers_fct_ap.ctaxcountryid is '报税货国家/地区';
comment on column ${iol_schema}.iers_fct_ap.ctname is '合同名称';
comment on column ${iol_schema}.iers_fct_ap.ctname2 is '合同名称2';
comment on column ${iol_schema}.iers_fct_ap.ctname3 is '合同名称3';
comment on column ${iol_schema}.iers_fct_ap.ctname4 is '合同名称4';
comment on column ${iol_schema}.iers_fct_ap.ctname5 is '合同名称5';
comment on column ${iol_schema}.iers_fct_ap.ctname6 is '合同名称6';
comment on column ${iol_schema}.iers_fct_ap.ctrantypeid is '合同类型';
comment on column ${iol_schema}.iers_fct_ap.custunit is '对方单位说明';
comment on column ${iol_schema}.iers_fct_ap.cvendorid is '供应商';
comment on column ${iol_schema}.iers_fct_ap.dbilldate is '单据日期';
comment on column ${iol_schema}.iers_fct_ap.deliaddr is '交货地点';
comment on column ${iol_schema}.iers_fct_ap.depid is '承办部门';
comment on column ${iol_schema}.iers_fct_ap.depid_v is '承办部门版本';
comment on column ${iol_schema}.iers_fct_ap.dmakedate is '制单日期';
comment on column ${iol_schema}.iers_fct_ap.dr is '删除标志';
comment on column ${iol_schema}.iers_fct_ap.earlysign is '期初标志';
comment on column ${iol_schema}.iers_fct_ap.fbuysellflag is '购销类型';
comment on column ${iol_schema}.iers_fct_ap.fstatusflag is '合同状态';
comment on column ${iol_schema}.iers_fct_ap.invallidate is '计划终止日期';
comment on column ${iol_schema}.iers_fct_ap.iprintcount is '打印次数';
comment on column ${iol_schema}.iers_fct_ap.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_fct_ap.modifier is '最后修改人';
comment on column ${iol_schema}.iers_fct_ap.mountcalculation is '计划金额计算方式';
comment on column ${iol_schema}.iers_fct_ap.nexchangerate is '折本汇率';
comment on column ${iol_schema}.iers_fct_ap.nglobalexchgrate is '全局本位币汇率';
comment on column ${iol_schema}.iers_fct_ap.ngroupexchgrate is '集团本位币汇率';
comment on column ${iol_schema}.iers_fct_ap.norigcopamount is '累计原币应付金额';
comment on column ${iol_schema}.iers_fct_ap.norigplanamount is '累计原币预付款金额';
comment on column ${iol_schema}.iers_fct_ap.norigpshamount is '累计原币付款金额';
comment on column ${iol_schema}.iers_fct_ap.norikpmny is '累计原币收票金额';
comment on column ${iol_schema}.iers_fct_ap.noriprepaylimitmny is '预付款限额';
comment on column ${iol_schema}.iers_fct_ap.noriprepaymny is '预付款';
comment on column ${iol_schema}.iers_fct_ap.nprepaylimitmny is '本币预付款限额';
comment on column ${iol_schema}.iers_fct_ap.nprepaymny is '本币预付款';
comment on column ${iol_schema}.iers_fct_ap.ntotalastnum is '总数量';
comment on column ${iol_schema}.iers_fct_ap.ntotalcopamount is '累计本币应付金额';
comment on column ${iol_schema}.iers_fct_ap.ntotalgpamount is '累计本币付款金额';
comment on column ${iol_schema}.iers_fct_ap.ntotalorigmny is '原币价税合计';
comment on column ${iol_schema}.iers_fct_ap.ntotalplanamount is '累计本币预付款金额';
comment on column ${iol_schema}.iers_fct_ap.ntotaltaxmny is '本币价税合计';
comment on column ${iol_schema}.iers_fct_ap.openct is '是否敞口合同';
comment on column ${iol_schema}.iers_fct_ap.organizer is '承办组织';
comment on column ${iol_schema}.iers_fct_ap.organizer_v is '承办组织版本';
comment on column ${iol_schema}.iers_fct_ap.ourbankaccount is '本方银行账号';
comment on column ${iol_schema}.iers_fct_ap.oursignatory is '本方签字人';
comment on column ${iol_schema}.iers_fct_ap.overrate is '超合同付款比例';
comment on column ${iol_schema}.iers_fct_ap.personnelid is '承办人员';
comment on column ${iol_schema}.iers_fct_ap.pk_fct_ap is '付款合同主键';
comment on column ${iol_schema}.iers_fct_ap.pk_group is '集团';
comment on column ${iol_schema}.iers_fct_ap.pk_org is '财务组织';
comment on column ${iol_schema}.iers_fct_ap.pk_org_v is '财务组织版本';
comment on column ${iol_schema}.iers_fct_ap.pk_origct is '原始主键';
comment on column ${iol_schema}.iers_fct_ap.pk_payterm is '付款协议';
comment on column ${iol_schema}.iers_fct_ap.saga_btxid is '';
comment on column ${iol_schema}.iers_fct_ap.saga_frozen is '';
comment on column ${iol_schema}.iers_fct_ap.saga_gtxid is '';
comment on column ${iol_schema}.iers_fct_ap.saga_status is '';
comment on column ${iol_schema}.iers_fct_ap.signatory is '对方签字人';
comment on column ${iol_schema}.iers_fct_ap.signorg is '签约组织';
comment on column ${iol_schema}.iers_fct_ap.signorg_v is '签约组织版本';
comment on column ${iol_schema}.iers_fct_ap.subscribedate is '签字盖章日期';
comment on column ${iol_schema}.iers_fct_ap.taudittime is '审批日期';
comment on column ${iol_schema}.iers_fct_ap.taxpayernumber is '对方纳税人识别号';
comment on column ${iol_schema}.iers_fct_ap.ts is '时间戳';
comment on column ${iol_schema}.iers_fct_ap.unconfpayableorg is '未确认本币应付金额';
comment on column ${iol_schema}.iers_fct_ap.unconfpayableori is '未确认原币应付金额';
comment on column ${iol_schema}.iers_fct_ap.unconfpaymentorg is '未确认本币付款金额';
comment on column ${iol_schema}.iers_fct_ap.unconfpaymentori is '未确认原币付款金额';
comment on column ${iol_schema}.iers_fct_ap.valdate is '计划生效日期';
comment on column ${iol_schema}.iers_fct_ap.vbillcode is '合同编码';
comment on column ${iol_schema}.iers_fct_ap.vdef1 is '自定义项1';
comment on column ${iol_schema}.iers_fct_ap.vdef10 is '自定义项10';
comment on column ${iol_schema}.iers_fct_ap.vdef11 is '自定义项11';
comment on column ${iol_schema}.iers_fct_ap.vdef12 is '自定义项12';
comment on column ${iol_schema}.iers_fct_ap.vdef13 is '自定义项13';
comment on column ${iol_schema}.iers_fct_ap.vdef14 is '自定义项14';
comment on column ${iol_schema}.iers_fct_ap.vdef15 is '自定义项15';
comment on column ${iol_schema}.iers_fct_ap.vdef16 is '自定义项16';
comment on column ${iol_schema}.iers_fct_ap.vdef17 is '自定义项17';
comment on column ${iol_schema}.iers_fct_ap.vdef18 is '自定义项18';
comment on column ${iol_schema}.iers_fct_ap.vdef19 is '自定义项19';
comment on column ${iol_schema}.iers_fct_ap.vdef2 is '自定义项2';
comment on column ${iol_schema}.iers_fct_ap.vdef20 is '自定义项20';
comment on column ${iol_schema}.iers_fct_ap.vdef21 is '自定义项21';
comment on column ${iol_schema}.iers_fct_ap.vdef22 is '自定义项22';
comment on column ${iol_schema}.iers_fct_ap.vdef23 is '自定义项23';
comment on column ${iol_schema}.iers_fct_ap.vdef24 is '自定义项24';
comment on column ${iol_schema}.iers_fct_ap.vdef25 is '自定义项25';
comment on column ${iol_schema}.iers_fct_ap.vdef26 is '自定义项26';
comment on column ${iol_schema}.iers_fct_ap.vdef27 is '自定义项27';
comment on column ${iol_schema}.iers_fct_ap.vdef28 is '自定义项28';
comment on column ${iol_schema}.iers_fct_ap.vdef29 is '自定义项29';
comment on column ${iol_schema}.iers_fct_ap.vdef3 is '自定义项3';
comment on column ${iol_schema}.iers_fct_ap.vdef30 is '自定义项30';
comment on column ${iol_schema}.iers_fct_ap.vdef31 is '自定义项31';
comment on column ${iol_schema}.iers_fct_ap.vdef32 is '自定义项32';
comment on column ${iol_schema}.iers_fct_ap.vdef33 is '自定义项33';
comment on column ${iol_schema}.iers_fct_ap.vdef34 is '自定义项34';
comment on column ${iol_schema}.iers_fct_ap.vdef35 is '自定义项35';
comment on column ${iol_schema}.iers_fct_ap.vdef36 is '自定义项36';
comment on column ${iol_schema}.iers_fct_ap.vdef37 is '自定义项37';
comment on column ${iol_schema}.iers_fct_ap.vdef38 is '自定义项38';
comment on column ${iol_schema}.iers_fct_ap.vdef39 is '自定义项39';
comment on column ${iol_schema}.iers_fct_ap.vdef4 is '自定义项4';
comment on column ${iol_schema}.iers_fct_ap.vdef40 is '自定义项40';
comment on column ${iol_schema}.iers_fct_ap.vdef41 is '自定义项41';
comment on column ${iol_schema}.iers_fct_ap.vdef42 is '自定义项42';
comment on column ${iol_schema}.iers_fct_ap.vdef43 is '自定义项43';
comment on column ${iol_schema}.iers_fct_ap.vdef44 is '自定义项44';
comment on column ${iol_schema}.iers_fct_ap.vdef45 is '自定义项45';
comment on column ${iol_schema}.iers_fct_ap.vdef46 is '自定义项46';
comment on column ${iol_schema}.iers_fct_ap.vdef47 is '自定义项47';
comment on column ${iol_schema}.iers_fct_ap.vdef48 is '自定义项48';
comment on column ${iol_schema}.iers_fct_ap.vdef49 is '自定义项49';
comment on column ${iol_schema}.iers_fct_ap.vdef5 is '自定义项5';
comment on column ${iol_schema}.iers_fct_ap.vdef50 is '自定义项50';
comment on column ${iol_schema}.iers_fct_ap.vdef51 is '自定义项51';
comment on column ${iol_schema}.iers_fct_ap.vdef52 is '自定义项52';
comment on column ${iol_schema}.iers_fct_ap.vdef53 is '自定义项53';
comment on column ${iol_schema}.iers_fct_ap.vdef54 is '自定义项54';
comment on column ${iol_schema}.iers_fct_ap.vdef55 is '自定义项55';
comment on column ${iol_schema}.iers_fct_ap.vdef56 is '自定义项56';
comment on column ${iol_schema}.iers_fct_ap.vdef57 is '自定义项57';
comment on column ${iol_schema}.iers_fct_ap.vdef58 is '自定义项58';
comment on column ${iol_schema}.iers_fct_ap.vdef59 is '自定义项59';
comment on column ${iol_schema}.iers_fct_ap.vdef6 is '自定义项6';
comment on column ${iol_schema}.iers_fct_ap.vdef60 is '自定义项60';
comment on column ${iol_schema}.iers_fct_ap.vdef61 is '自定义项61';
comment on column ${iol_schema}.iers_fct_ap.vdef62 is '自定义项62';
comment on column ${iol_schema}.iers_fct_ap.vdef63 is '自定义项63';
comment on column ${iol_schema}.iers_fct_ap.vdef64 is '自定义项64';
comment on column ${iol_schema}.iers_fct_ap.vdef65 is '自定义项65';
comment on column ${iol_schema}.iers_fct_ap.vdef66 is '自定义项66';
comment on column ${iol_schema}.iers_fct_ap.vdef67 is '自定义项67';
comment on column ${iol_schema}.iers_fct_ap.vdef68 is '自定义项68';
comment on column ${iol_schema}.iers_fct_ap.vdef69 is '自定义项69';
comment on column ${iol_schema}.iers_fct_ap.vdef7 is '自定义项7';
comment on column ${iol_schema}.iers_fct_ap.vdef70 is '自定义项70';
comment on column ${iol_schema}.iers_fct_ap.vdef71 is '自定义项71';
comment on column ${iol_schema}.iers_fct_ap.vdef72 is '自定义项72';
comment on column ${iol_schema}.iers_fct_ap.vdef73 is '自定义项73';
comment on column ${iol_schema}.iers_fct_ap.vdef74 is '自定义项74';
comment on column ${iol_schema}.iers_fct_ap.vdef75 is '自定义项75';
comment on column ${iol_schema}.iers_fct_ap.vdef76 is '自定义项76';
comment on column ${iol_schema}.iers_fct_ap.vdef77 is '自定义项77';
comment on column ${iol_schema}.iers_fct_ap.vdef78 is '自定义项78';
comment on column ${iol_schema}.iers_fct_ap.vdef79 is '自定义项79';
comment on column ${iol_schema}.iers_fct_ap.vdef8 is '自定义项8';
comment on column ${iol_schema}.iers_fct_ap.vdef80 is '自定义项80';
comment on column ${iol_schema}.iers_fct_ap.vdef81 is '自定义项81';
comment on column ${iol_schema}.iers_fct_ap.vdef82 is '自定义项82';
comment on column ${iol_schema}.iers_fct_ap.vdef83 is '自定义项83';
comment on column ${iol_schema}.iers_fct_ap.vdef84 is '自定义项84';
comment on column ${iol_schema}.iers_fct_ap.vdef85 is '自定义项85';
comment on column ${iol_schema}.iers_fct_ap.vdef86 is '自定义项86';
comment on column ${iol_schema}.iers_fct_ap.vdef87 is '自定义项87';
comment on column ${iol_schema}.iers_fct_ap.vdef88 is '自定义项88';
comment on column ${iol_schema}.iers_fct_ap.vdef89 is '自定义项89';
comment on column ${iol_schema}.iers_fct_ap.vdef9 is '自定义项9';
comment on column ${iol_schema}.iers_fct_ap.vdef90 is '自定义项90';
comment on column ${iol_schema}.iers_fct_ap.version is '版本号';
comment on column ${iol_schema}.iers_fct_ap.vtrantypecode is '合同类型编码';
comment on column ${iol_schema}.iers_fct_ap.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fct_ap.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fct_ap.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fct_ap.etl_timestamp is 'ETL处理时间戳';
