/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_putout_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_putout_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_putout_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_putout_apply(
    serialno varchar2(64) -- 信贷唯一主键约束
    ,brno varchar2(10) -- 合作机构号
    ,seqno varchar2(32) -- 流水号
    ,corpname varchar2(150) -- 企业全称
    ,regarea varchar2(10) -- 注册国家或地区
    ,regadmarea varchar2(10) -- 注册地行政区划
    ,regaddress varchar2(500) -- 注册地址
    ,province varchar2(100) -- 省份
    ,orgcode varchar2(30) -- 组织机构代码
    ,regtype varchar2(10) -- 注册或登记证件类型
    ,regnumber varchar2(100) -- 注册或登记证件号码
    ,taxnumber varchar2(50) -- 税务登记证号码
    ,socialunifiedcreditcode varchar2(18) -- 社会统一信用代码
    ,category varchar2(10) -- 国标行业分类
    ,busscale varchar2(2) -- 企业规模代码
    ,smallcorpiden varchar2(2) -- 银监会小企业标识
    ,custname varchar2(128) -- 法人名称
    ,idtype varchar2(10) -- 证件类型代码
    ,idno varchar2(32) -- 证件编号
    ,sex varchar2(1) -- 性别代码
    ,nationality varchar2(64) -- 国籍代码
    ,career varchar2(4) -- 职业代码
    ,birth varchar2(8) -- 出生日
    ,telno varchar2(20) -- 联系电话号码
    ,phoneno varchar2(15) -- 手机号码
    ,pactamt number(24,6) -- 贷款合同金额
    ,lnrate number(24,6) -- 利率（年）
    ,apparea varchar2(6) -- 申请地点
    ,appuse varchar2(2) -- 申请用途
    ,termmon varchar2(2) -- 合同期限（月）
    ,voutype varchar2(2) -- 担保方式代码
    ,enddate varchar2(8) -- 到期日
    ,paytype varchar2(2) -- 扣款日类型
    ,payday varchar2(8) -- 扣款日期
    ,merchantno varchar2(64) -- 商户号
    ,busilicenseid varchar2(64) -- 营业执照号
    ,busilicenseexpiredate varchar2(64) -- 营业执照有效截止日期
    ,registerdate varchar2(64) -- 成立日期
    ,operatinglife varchar2(64) -- 经营年限
    ,staffnumber varchar2(64) -- 员工人数
    ,needrefuse varchar2(64) -- 需要拒绝
    ,legalbankcard varchar2(64) -- 银行卡号
    ,legalmobile varchar2(64) -- 手机号码
    ,quotamod number(24,6) -- 模型核额额度
    ,custlevel varchar2(10) -- 内部评级
    ,loannum varchar2(32) -- 贷款笔数
    ,enterprisecerttype varchar2(10) -- 企业证件类型
    ,enterprisecertendtime date -- 企业证件到期日
    ,custid varchar2(32) -- ECIF客户号
    ,signingenpauthtime date -- 企业征信授权书签署时间
    ,signingpersonauthtime date -- 个人征信授权书签署时间
    ,signingenpauthseq varchar2(64) -- 企业征信授权书签署流水号
    ,signingpersonauthseq varchar2(64) -- 个人征信授权书签署流水号
    ,loantype varchar2(4) -- 贷款形式
    ,loanacctno varchar2(64) -- 原借据号
    ,guarantytype varchar2(10) -- 是否银担业务
    ,guarantyorgname varchar2(200) -- 担保公司名称
    ,guarantycerttype varchar2(10) -- 担保公司证件类型
    ,guarantycertno varchar2(64) -- 担保公司证件号码
    ,guarantypercent number(12,4) -- 担保比例
    ,effectivedate varchar2(64) -- 法人身份证生效日期
    ,expiredate varchar2(64) -- 法人身份证失效日期
    ,appointdate varchar2(64) -- 预约放款日期
    ,transstatus varchar2(6) -- 交易状态
    ,mybankaffiliateflag varchar2(6) -- 是否我行关联人
    ,zhengxincheckresult varchar2(6) -- 征信校验结果
    ,gongancheckresult varchar2(6) -- 公安联网核查结果
    ,productid varchar2(48) -- 产品编号
    ,manageuserid varchar2(32) -- 客户经理编号
    ,manageorgid varchar2(32) -- 客户经理机构编号
    ,applytime date -- 申请时间
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,fkreleasetime date -- 风控返回时间
    ,baseratetype varchar2(4) -- 基准利率类型
    ,customerid varchar2(16) -- 客户编号
    ,zzm varchar2(64) -- 中征码
    ,entscale varchar2(10) -- 企业规模（行内）
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
grant select on ${iol_schema}.icms_wyd_putout_apply to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_putout_apply to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_putout_apply to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_putout_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_putout_apply is '微业贷放款申请';
comment on column ${iol_schema}.icms_wyd_putout_apply.serialno is '信贷唯一主键约束';
comment on column ${iol_schema}.icms_wyd_putout_apply.brno is '合作机构号';
comment on column ${iol_schema}.icms_wyd_putout_apply.seqno is '流水号';
comment on column ${iol_schema}.icms_wyd_putout_apply.corpname is '企业全称';
comment on column ${iol_schema}.icms_wyd_putout_apply.regarea is '注册国家或地区';
comment on column ${iol_schema}.icms_wyd_putout_apply.regadmarea is '注册地行政区划';
comment on column ${iol_schema}.icms_wyd_putout_apply.regaddress is '注册地址';
comment on column ${iol_schema}.icms_wyd_putout_apply.province is '省份';
comment on column ${iol_schema}.icms_wyd_putout_apply.orgcode is '组织机构代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.regtype is '注册或登记证件类型';
comment on column ${iol_schema}.icms_wyd_putout_apply.regnumber is '注册或登记证件号码';
comment on column ${iol_schema}.icms_wyd_putout_apply.taxnumber is '税务登记证号码';
comment on column ${iol_schema}.icms_wyd_putout_apply.socialunifiedcreditcode is '社会统一信用代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.category is '国标行业分类';
comment on column ${iol_schema}.icms_wyd_putout_apply.busscale is '企业规模代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.smallcorpiden is '银监会小企业标识';
comment on column ${iol_schema}.icms_wyd_putout_apply.custname is '法人名称';
comment on column ${iol_schema}.icms_wyd_putout_apply.idtype is '证件类型代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.idno is '证件编号';
comment on column ${iol_schema}.icms_wyd_putout_apply.sex is '性别代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.nationality is '国籍代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.career is '职业代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.birth is '出生日';
comment on column ${iol_schema}.icms_wyd_putout_apply.telno is '联系电话号码';
comment on column ${iol_schema}.icms_wyd_putout_apply.phoneno is '手机号码';
comment on column ${iol_schema}.icms_wyd_putout_apply.pactamt is '贷款合同金额';
comment on column ${iol_schema}.icms_wyd_putout_apply.lnrate is '利率（年）';
comment on column ${iol_schema}.icms_wyd_putout_apply.apparea is '申请地点';
comment on column ${iol_schema}.icms_wyd_putout_apply.appuse is '申请用途';
comment on column ${iol_schema}.icms_wyd_putout_apply.termmon is '合同期限（月）';
comment on column ${iol_schema}.icms_wyd_putout_apply.voutype is '担保方式代码';
comment on column ${iol_schema}.icms_wyd_putout_apply.enddate is '到期日';
comment on column ${iol_schema}.icms_wyd_putout_apply.paytype is '扣款日类型';
comment on column ${iol_schema}.icms_wyd_putout_apply.payday is '扣款日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.merchantno is '商户号';
comment on column ${iol_schema}.icms_wyd_putout_apply.busilicenseid is '营业执照号';
comment on column ${iol_schema}.icms_wyd_putout_apply.busilicenseexpiredate is '营业执照有效截止日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.registerdate is '成立日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.operatinglife is '经营年限';
comment on column ${iol_schema}.icms_wyd_putout_apply.staffnumber is '员工人数';
comment on column ${iol_schema}.icms_wyd_putout_apply.needrefuse is '需要拒绝';
comment on column ${iol_schema}.icms_wyd_putout_apply.legalbankcard is '银行卡号';
comment on column ${iol_schema}.icms_wyd_putout_apply.legalmobile is '手机号码';
comment on column ${iol_schema}.icms_wyd_putout_apply.quotamod is '模型核额额度';
comment on column ${iol_schema}.icms_wyd_putout_apply.custlevel is '内部评级';
comment on column ${iol_schema}.icms_wyd_putout_apply.loannum is '贷款笔数';
comment on column ${iol_schema}.icms_wyd_putout_apply.enterprisecerttype is '企业证件类型';
comment on column ${iol_schema}.icms_wyd_putout_apply.enterprisecertendtime is '企业证件到期日';
comment on column ${iol_schema}.icms_wyd_putout_apply.custid is 'ECIF客户号';
comment on column ${iol_schema}.icms_wyd_putout_apply.signingenpauthtime is '企业征信授权书签署时间';
comment on column ${iol_schema}.icms_wyd_putout_apply.signingpersonauthtime is '个人征信授权书签署时间';
comment on column ${iol_schema}.icms_wyd_putout_apply.signingenpauthseq is '企业征信授权书签署流水号';
comment on column ${iol_schema}.icms_wyd_putout_apply.signingpersonauthseq is '个人征信授权书签署流水号';
comment on column ${iol_schema}.icms_wyd_putout_apply.loantype is '贷款形式';
comment on column ${iol_schema}.icms_wyd_putout_apply.loanacctno is '原借据号';
comment on column ${iol_schema}.icms_wyd_putout_apply.guarantytype is '是否银担业务';
comment on column ${iol_schema}.icms_wyd_putout_apply.guarantyorgname is '担保公司名称';
comment on column ${iol_schema}.icms_wyd_putout_apply.guarantycerttype is '担保公司证件类型';
comment on column ${iol_schema}.icms_wyd_putout_apply.guarantycertno is '担保公司证件号码';
comment on column ${iol_schema}.icms_wyd_putout_apply.guarantypercent is '担保比例';
comment on column ${iol_schema}.icms_wyd_putout_apply.effectivedate is '法人身份证生效日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.expiredate is '法人身份证失效日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.appointdate is '预约放款日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.transstatus is '交易状态';
comment on column ${iol_schema}.icms_wyd_putout_apply.mybankaffiliateflag is '是否我行关联人';
comment on column ${iol_schema}.icms_wyd_putout_apply.zhengxincheckresult is '征信校验结果';
comment on column ${iol_schema}.icms_wyd_putout_apply.gongancheckresult is '公安联网核查结果';
comment on column ${iol_schema}.icms_wyd_putout_apply.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_putout_apply.manageuserid is '客户经理编号';
comment on column ${iol_schema}.icms_wyd_putout_apply.manageorgid is '客户经理机构编号';
comment on column ${iol_schema}.icms_wyd_putout_apply.applytime is '申请时间';
comment on column ${iol_schema}.icms_wyd_putout_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_putout_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wyd_putout_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_putout_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_putout_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.fkreleasetime is '风控返回时间';
comment on column ${iol_schema}.icms_wyd_putout_apply.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_wyd_putout_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_wyd_putout_apply.zzm is '中征码';
comment on column ${iol_schema}.icms_wyd_putout_apply.entscale is '企业规模（行内）';
comment on column ${iol_schema}.icms_wyd_putout_apply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_putout_apply.etl_timestamp is 'ETL处理时间戳';
