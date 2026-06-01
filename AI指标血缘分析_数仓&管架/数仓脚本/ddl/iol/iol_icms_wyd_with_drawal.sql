/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_with_drawal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_with_drawal
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_with_drawal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_with_drawal(
    serialno varchar2(64) -- 流水号
    ,coorgnum varchar2(10) -- 合作机构号
    ,applseqnum varchar2(32) -- 申请流水号
    ,lrrserialno varchar2(64) -- 微业贷额度结果接收流水号
    ,intfccalltm varchar2(30) -- 接口调用时间
    ,stlprdcd varchar2(10) -- 核算产品代码
    ,ddtyp varchar2(4) -- 放款类型
    ,refe varchar2(30) -- 推荐人
    ,ccy varchar2(8) -- 币种
    ,contramt number(16,2) -- 合同金额
    ,precdddate varchar2(10) -- 预约放款日期
    ,applsiteregion varchar2(10) -- 申请地点区划
    ,applusage varchar2(4) -- 申请用途
    ,wzguarmode varchar2(4) -- 微众担保方式
    ,dedudate varchar2(4) -- 扣款日
    ,taxpidennum varchar2(25) -- 纳税人识别号
    ,corpfname varchar2(150) -- 企业全称
    ,ptyecif varchar2(32) -- 客户CCIF
    ,regctyzone varchar2(6) -- 注册国家或地区
    ,natnregion varchar2(10) -- 注册地行政区划
    ,regloc varchar2(500) -- 注册地址
    ,prov varchar2(20) -- 省份
    ,orgcd varchar2(50) -- 组织机构代码
    ,csldsocicrdtid varchar2(50) -- 统一社会信用编号
    ,inducomregnum varchar2(50) -- 工商注册号
    ,operlicencevalidenddt varchar2(10) -- 营业执照有效截止日期
    ,gbinduclass varchar2(10) -- 国标行业分类
    ,wzcorpsize varchar2(2) -- 微众企业规模
    ,cbrcsmallcorpind varchar2(2) -- 银监会小企业标识
    ,estabdt varchar2(10) -- 成立日期
    ,operyears varchar2(10) -- 经营年限
    ,empcnt varchar2(10) -- 员工人数
    ,lpname varchar2(200) -- 法定代表人名称
    ,lpecif varchar2(32) -- 法人ECIF
    ,lpcerttyp varchar2(4) -- 法人证件类型
    ,lpcertnum varchar2(32) -- 法人证件号码
    ,lpcertexpidate varchar2(10) -- 法人证件失效日期
    ,lpgend varchar2(2) -- 法人性别
    ,lpethnic varchar2(4) -- 法人民族
    ,lpcertadr varchar2(128) -- 法人证件地址
    ,lpnation varchar2(10) -- 法人国籍
    ,lpcareer varchar2(4) -- 法人职业
    ,lpbirthdt varchar2(10) -- 法人出生日期
    ,lpcephnum varchar2(20) -- 法人手机号码
    ,certbankcardnum varchar2(50) -- 认证银行卡号
    ,certcephnum varchar2(20) -- 认证手机号码
    ,corpcitauthsigntm varchar2(20) -- 企业征信授权书签署时间
    ,indvcitauthsigntm varchar2(20) -- 个人征信授权书签署时间
    ,corpcitauthsignseq varchar2(32) -- 企业征信授权书签署流水号
    ,indvcitauthsignseq varchar2(32) -- 个人征信授权书签署流水号
    ,facecertresu varchar2(32) -- 人脸认证结果
    ,finalcfmlmt number(21,2) -- 最终确认额度
    ,modelquotalmt number(21,2) -- 模型核额额度
    ,coopupdalmt number(21,2) -- 合作方修改额度
    ,lastchklmtdate varchar2(20) -- 最近核额时间
    ,interrat varchar2(4) -- 内部评级
    ,loancnt varchar2(4) -- 贷款笔数
    ,loanform varchar2(4) -- 贷款形式
    ,origdbillnum varchar2(64) -- 原借据号
    ,wthrguarbiz varchar2(4) -- 是否担保业务
    ,guartcompanyname varchar2(200) -- 担保公司名称
    ,guarcorpcerttyp varchar2(10) -- 担保公司证件类型
    ,guarcorpcertnum varchar2(50) -- 担保公司证件号码
    ,guarratio number(14,4) -- 担保比例
    ,customerid varchar2(32) -- 客户编号
    ,riskresult varchar2(12) -- 风控结果
    ,isfirstloan varchar2(1) -- 是否首贷
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_wyd_with_drawal to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_with_drawal to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_with_drawal to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_with_drawal to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_with_drawal is '微业贷提款准入表';
comment on column ${iol_schema}.icms_wyd_with_drawal.serialno is '流水号';
comment on column ${iol_schema}.icms_wyd_with_drawal.coorgnum is '合作机构号';
comment on column ${iol_schema}.icms_wyd_with_drawal.applseqnum is '申请流水号';
comment on column ${iol_schema}.icms_wyd_with_drawal.lrrserialno is '微业贷额度结果接收流水号';
comment on column ${iol_schema}.icms_wyd_with_drawal.intfccalltm is '接口调用时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.stlprdcd is '核算产品代码';
comment on column ${iol_schema}.icms_wyd_with_drawal.ddtyp is '放款类型';
comment on column ${iol_schema}.icms_wyd_with_drawal.refe is '推荐人';
comment on column ${iol_schema}.icms_wyd_with_drawal.ccy is '币种';
comment on column ${iol_schema}.icms_wyd_with_drawal.contramt is '合同金额';
comment on column ${iol_schema}.icms_wyd_with_drawal.precdddate is '预约放款日期';
comment on column ${iol_schema}.icms_wyd_with_drawal.applsiteregion is '申请地点区划';
comment on column ${iol_schema}.icms_wyd_with_drawal.applusage is '申请用途';
comment on column ${iol_schema}.icms_wyd_with_drawal.wzguarmode is '微众担保方式';
comment on column ${iol_schema}.icms_wyd_with_drawal.dedudate is '扣款日';
comment on column ${iol_schema}.icms_wyd_with_drawal.taxpidennum is '纳税人识别号';
comment on column ${iol_schema}.icms_wyd_with_drawal.corpfname is '企业全称';
comment on column ${iol_schema}.icms_wyd_with_drawal.ptyecif is '客户CCIF';
comment on column ${iol_schema}.icms_wyd_with_drawal.regctyzone is '注册国家或地区';
comment on column ${iol_schema}.icms_wyd_with_drawal.natnregion is '注册地行政区划';
comment on column ${iol_schema}.icms_wyd_with_drawal.regloc is '注册地址';
comment on column ${iol_schema}.icms_wyd_with_drawal.prov is '省份';
comment on column ${iol_schema}.icms_wyd_with_drawal.orgcd is '组织机构代码';
comment on column ${iol_schema}.icms_wyd_with_drawal.csldsocicrdtid is '统一社会信用编号';
comment on column ${iol_schema}.icms_wyd_with_drawal.inducomregnum is '工商注册号';
comment on column ${iol_schema}.icms_wyd_with_drawal.operlicencevalidenddt is '营业执照有效截止日期';
comment on column ${iol_schema}.icms_wyd_with_drawal.gbinduclass is '国标行业分类';
comment on column ${iol_schema}.icms_wyd_with_drawal.wzcorpsize is '微众企业规模';
comment on column ${iol_schema}.icms_wyd_with_drawal.cbrcsmallcorpind is '银监会小企业标识';
comment on column ${iol_schema}.icms_wyd_with_drawal.estabdt is '成立日期';
comment on column ${iol_schema}.icms_wyd_with_drawal.operyears is '经营年限';
comment on column ${iol_schema}.icms_wyd_with_drawal.empcnt is '员工人数';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpname is '法定代表人名称';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpecif is '法人ECIF';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpcerttyp is '法人证件类型';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpcertnum is '法人证件号码';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpcertexpidate is '法人证件失效日期';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpgend is '法人性别';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpethnic is '法人民族';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpcertadr is '法人证件地址';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpnation is '法人国籍';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpcareer is '法人职业';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpbirthdt is '法人出生日期';
comment on column ${iol_schema}.icms_wyd_with_drawal.lpcephnum is '法人手机号码';
comment on column ${iol_schema}.icms_wyd_with_drawal.certbankcardnum is '认证银行卡号';
comment on column ${iol_schema}.icms_wyd_with_drawal.certcephnum is '认证手机号码';
comment on column ${iol_schema}.icms_wyd_with_drawal.corpcitauthsigntm is '企业征信授权书签署时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.indvcitauthsigntm is '个人征信授权书签署时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.corpcitauthsignseq is '企业征信授权书签署流水号';
comment on column ${iol_schema}.icms_wyd_with_drawal.indvcitauthsignseq is '个人征信授权书签署流水号';
comment on column ${iol_schema}.icms_wyd_with_drawal.facecertresu is '人脸认证结果';
comment on column ${iol_schema}.icms_wyd_with_drawal.finalcfmlmt is '最终确认额度';
comment on column ${iol_schema}.icms_wyd_with_drawal.modelquotalmt is '模型核额额度';
comment on column ${iol_schema}.icms_wyd_with_drawal.coopupdalmt is '合作方修改额度';
comment on column ${iol_schema}.icms_wyd_with_drawal.lastchklmtdate is '最近核额时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.interrat is '内部评级';
comment on column ${iol_schema}.icms_wyd_with_drawal.loancnt is '贷款笔数';
comment on column ${iol_schema}.icms_wyd_with_drawal.loanform is '贷款形式';
comment on column ${iol_schema}.icms_wyd_with_drawal.origdbillnum is '原借据号';
comment on column ${iol_schema}.icms_wyd_with_drawal.wthrguarbiz is '是否担保业务';
comment on column ${iol_schema}.icms_wyd_with_drawal.guartcompanyname is '担保公司名称';
comment on column ${iol_schema}.icms_wyd_with_drawal.guarcorpcerttyp is '担保公司证件类型';
comment on column ${iol_schema}.icms_wyd_with_drawal.guarcorpcertnum is '担保公司证件号码';
comment on column ${iol_schema}.icms_wyd_with_drawal.guarratio is '担保比例';
comment on column ${iol_schema}.icms_wyd_with_drawal.customerid is '客户编号';
comment on column ${iol_schema}.icms_wyd_with_drawal.riskresult is '风控结果';
comment on column ${iol_schema}.icms_wyd_with_drawal.isfirstloan is '是否首贷';
comment on column ${iol_schema}.icms_wyd_with_drawal.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_with_drawal.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wyd_with_drawal.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_with_drawal.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_with_drawal.updatedate is '更新时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wyd_with_drawal.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wyd_with_drawal.etl_timestamp is 'ETL处理时间戳';
