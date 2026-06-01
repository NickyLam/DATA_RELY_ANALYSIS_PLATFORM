/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_transfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_transfer
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_transfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_transfer(
    serialno varchar2(32) -- 流水号
    ,riskrank varchar2(60) -- 风险等级
    ,bal varchar2(60) -- 贷款余额(元)
    ,guaranteeitem varchar2(60) -- 担保品
    ,ischeckinspect varchar2(10) -- 联网核查是否通过
    ,province varchar2(60) -- 地区省份
    ,statusdesc varchar2(60) -- 经营状态
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,userage varchar2(60) -- 年龄
    ,reminddays varchar2(60) -- 贷款剩余期限（天）
    ,registerfund varchar2(60) -- 注册资本
    ,inputid varchar2(10) -- 客户经理
    ,intrate varchar2(60) -- 贷款利率（%）
    ,currentstatus varchar2(20) -- 当前状态
    ,inttype varchar2(60) -- 利率浮动方式
    ,creditbal varchar2(60) -- 单户授信（元）
    ,butpye varchar2(60) -- 企业类型
    ,registeraddress varchar2(200) -- 注册地址
    ,firstloanlengthgrade varchar2(60) -- 信贷时长等级
    ,assetclass varchar2(60) -- 贷款五级分类
    ,manageenddate varchar2(60) -- 经营结束时间
    ,repaymodedesc varchar2(60) -- 贷款付息方式(个月/次)
    ,isgetcuscode varchar2(10) -- 是否开户成功
    ,injectid varchar2(60) -- 转让批次号
    ,drawndnseqno varchar2(60) -- 支用编号
    ,companytype varchar2(90) -- 公司类型
    ,failreason varchar2(500) -- 拒绝原因
    ,mobileno varchar2(60) -- 借款人手机号码
    ,loanusetype varchar2(60) -- 贷款用途
    ,duedate varchar2(60) -- 贷款到期日
    ,lastcheckyear varchar2(60) -- 最后年检年度
    ,managebegindate varchar2(60) -- 经营开始时间
    ,ovdorderamt6mgrade varchar2(60) -- 最近六个月逾期金额等级
    ,registerdate varchar2(60) -- 注册时间
    ,registerdepartment varchar2(100) -- 注册工商局
    ,certtype varchar2(60) -- 借款人证件类型
    ,ovdordercnt6mgrade varchar2(60) -- 最近六个月逾期笔数等级
    ,positivebizcnt1ygrade varchar2(60) -- 最近一年履约等级
    ,registerno varchar2(60) -- 工商注册号
    ,inputdate varchar2(10) -- 下载日期
    ,termnum varchar2(60) -- 贷款期限（月）
    ,entityname varchar2(200) -- 公司名
    ,name varchar2(200) -- 借款人名称
    ,certno varchar2(60) -- 借款人证件号
    ,loantype varchar2(60) -- 贷款类型
    ,registeraddressareacode varchar2(60) -- 注册地行政区编号
    ,registeraddressarea varchar2(100) -- 注册地省市区
    ,approvestatus varchar2(20) -- 审批状态
    ,useraddress varchar2(250) -- 借款人住址
    ,guaranteemethod varchar2(60) -- 担保方式
    ,lawer varchar2(100) -- 法定代表人
    ,apprendtime varchar2(20) -- 审批结束时间
    ,currencytype varchar2(60) -- 币种
    ,amt varchar2(60) -- 合同金额(元)
    ,disbursedate varchar2(60) -- 贷款起息日
    ,managerange varchar2(200) -- 经营范围
    ,cusid varchar2(32) -- 客户号
    ,repaymentseg varchar2(60) -- 偿债能力
    ,ovdorderdays6mgrade varchar2(60) -- 最近六个月逾期天数等级
    ,riskscore varchar2(60) -- 风险分数
    ,ovdlog6m varchar2(60) -- 六个月逾期记录
    ,tradecode varchar2(60) -- 行业代码
    ,opendate varchar2(60) -- 开业时间
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
grant select on ${iol_schema}.icms_mybk_asset_transfer to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_transfer is '网商贷资产流转申请';
comment on column ${iol_schema}.icms_mybk_asset_transfer.serialno is '流水号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.riskrank is '风险等级';
comment on column ${iol_schema}.icms_mybk_asset_transfer.bal is '贷款余额(元)';
comment on column ${iol_schema}.icms_mybk_asset_transfer.guaranteeitem is '担保品';
comment on column ${iol_schema}.icms_mybk_asset_transfer.ischeckinspect is '联网核查是否通过';
comment on column ${iol_schema}.icms_mybk_asset_transfer.province is '地区省份';
comment on column ${iol_schema}.icms_mybk_asset_transfer.statusdesc is '经营状态';
comment on column ${iol_schema}.icms_mybk_asset_transfer.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_mybk_asset_transfer.userage is '年龄';
comment on column ${iol_schema}.icms_mybk_asset_transfer.reminddays is '贷款剩余期限（天）';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registerfund is '注册资本';
comment on column ${iol_schema}.icms_mybk_asset_transfer.inputid is '客户经理';
comment on column ${iol_schema}.icms_mybk_asset_transfer.intrate is '贷款利率（%）';
comment on column ${iol_schema}.icms_mybk_asset_transfer.currentstatus is '当前状态';
comment on column ${iol_schema}.icms_mybk_asset_transfer.inttype is '利率浮动方式';
comment on column ${iol_schema}.icms_mybk_asset_transfer.creditbal is '单户授信（元）';
comment on column ${iol_schema}.icms_mybk_asset_transfer.butpye is '企业类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registeraddress is '注册地址';
comment on column ${iol_schema}.icms_mybk_asset_transfer.firstloanlengthgrade is '信贷时长等级';
comment on column ${iol_schema}.icms_mybk_asset_transfer.assetclass is '贷款五级分类';
comment on column ${iol_schema}.icms_mybk_asset_transfer.manageenddate is '经营结束时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer.repaymodedesc is '贷款付息方式(个月/次)';
comment on column ${iol_schema}.icms_mybk_asset_transfer.isgetcuscode is '是否开户成功';
comment on column ${iol_schema}.icms_mybk_asset_transfer.injectid is '转让批次号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.drawndnseqno is '支用编号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.companytype is '公司类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_mybk_asset_transfer.mobileno is '借款人手机号码';
comment on column ${iol_schema}.icms_mybk_asset_transfer.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_mybk_asset_transfer.duedate is '贷款到期日';
comment on column ${iol_schema}.icms_mybk_asset_transfer.lastcheckyear is '最后年检年度';
comment on column ${iol_schema}.icms_mybk_asset_transfer.managebegindate is '经营开始时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer.ovdorderamt6mgrade is '最近六个月逾期金额等级';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registerdate is '注册时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registerdepartment is '注册工商局';
comment on column ${iol_schema}.icms_mybk_asset_transfer.certtype is '借款人证件类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer.ovdordercnt6mgrade is '最近六个月逾期笔数等级';
comment on column ${iol_schema}.icms_mybk_asset_transfer.positivebizcnt1ygrade is '最近一年履约等级';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registerno is '工商注册号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.inputdate is '下载日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer.termnum is '贷款期限（月）';
comment on column ${iol_schema}.icms_mybk_asset_transfer.entityname is '公司名';
comment on column ${iol_schema}.icms_mybk_asset_transfer.name is '借款人名称';
comment on column ${iol_schema}.icms_mybk_asset_transfer.certno is '借款人证件号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.loantype is '贷款类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registeraddressareacode is '注册地行政区编号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.registeraddressarea is '注册地省市区';
comment on column ${iol_schema}.icms_mybk_asset_transfer.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_mybk_asset_transfer.useraddress is '借款人住址';
comment on column ${iol_schema}.icms_mybk_asset_transfer.guaranteemethod is '担保方式';
comment on column ${iol_schema}.icms_mybk_asset_transfer.lawer is '法定代表人';
comment on column ${iol_schema}.icms_mybk_asset_transfer.apprendtime is '审批结束时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer.currencytype is '币种';
comment on column ${iol_schema}.icms_mybk_asset_transfer.amt is '合同金额(元)';
comment on column ${iol_schema}.icms_mybk_asset_transfer.disbursedate is '贷款起息日';
comment on column ${iol_schema}.icms_mybk_asset_transfer.managerange is '经营范围';
comment on column ${iol_schema}.icms_mybk_asset_transfer.cusid is '客户号';
comment on column ${iol_schema}.icms_mybk_asset_transfer.repaymentseg is '偿债能力';
comment on column ${iol_schema}.icms_mybk_asset_transfer.ovdorderdays6mgrade is '最近六个月逾期天数等级';
comment on column ${iol_schema}.icms_mybk_asset_transfer.riskscore is '风险分数';
comment on column ${iol_schema}.icms_mybk_asset_transfer.ovdlog6m is '六个月逾期记录';
comment on column ${iol_schema}.icms_mybk_asset_transfer.tradecode is '行业代码';
comment on column ${iol_schema}.icms_mybk_asset_transfer.opendate is '开业时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer.etl_timestamp is 'ETL处理时间戳';
