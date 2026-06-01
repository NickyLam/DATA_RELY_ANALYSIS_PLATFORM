/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_deposit_apply_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_deposit_apply_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_deposit_apply_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_deposit_apply_info(
    serialno varchar2(32) -- 申请流水号
    ,remake varchar2(200) -- 追加说明
    ,cusname varchar2(80) -- 客户名称
    ,grteac varchar2(40) -- 保证金帐号
    ,pigeonholedate date -- 归档日期
    ,pdrifv number(11,7) -- 浮动值
    ,inputorgid varchar2(40) -- 登记机构
    ,cntrtp varchar2(1) -- 协议类型1--承兑汇票协议 2–保函合同
    ,exchangedate date -- 交易日期
    ,otrvbldn varchar2(1) -- 表外记账方向
    ,crcycd varchar2(3) -- 币种
    ,otrvacno varchar2(40) -- 表外账号
    ,fxfltp varchar2(1) -- 利率类型（核心crgtrt加）
    ,approvestatus varchar2(18) -- 流程状态
    ,hascancel varchar2(2) -- 是否已撤销Y是N否默认可以为空
    ,isopen varchar2(2) -- 是否释放敞口
    ,batchserialno varchar2(32) -- 批次流水
    ,initexchangeserialno varchar2(32) -- 原交易流水号
    ,exchangetime date -- 交易日期
    ,interestrate number(24,6) -- 协议利率
    ,bailsum number(24,6) -- 已缴保证金金额
    ,inputuserid varchar2(8) -- 登记人
    ,updateuserid varchar2(8) -- 更新人
    ,contractno varchar2(40) -- 合同流水号
    ,putoutno varchar2(40) -- 出账流水号
    ,matudt date -- 到期日期票据到期日
    ,subaccount varchar2(40) -- 子户号
    ,exchangeserialno varchar2(32) -- 交易流水号
    ,businesstype varchar2(40) -- 转出业务类型
    ,otsusbtp varchar2(1) -- 冻结止付方式
    ,updateorgid varchar2(12) -- 更新机构
    ,tranam number(18,2) -- 金额
    ,exchangestate varchar2(2) -- 交易状态
    ,dataid varchar2(40) -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
    ,balance number(24,6) -- 业务余额
    ,inputdate date -- 登记日期
    ,grtetp varchar2(1) -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
    ,putoutdate date -- 业务起贷日
    ,pdrifd varchar2(3) -- 利率浮动类型
    ,isdiscountflag varchar2(10) -- 是否当前借款人
    ,migtflag varchar2(80) -- 
    ,cusid varchar2(40) -- 客户ID
    ,interestmethod varchar2(10) -- 计息方法
    ,maturity date -- 业务到期日
    ,prcsna varchar2(50) -- 表外摘要
    ,acptno varchar2(40) -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
    ,opertp varchar2(1) -- 操作类型1--建立保证金对应关系 2–追加保证金
    ,termcd varchar2(3) -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
    ,otfrsptp varchar2(1) -- 冻结止付类型
    ,otfzremk varchar2(100) -- 冻结止付原因
    ,initexchangedate date -- 原交易日期
    ,businesssum number(24,6) -- 业务金额
    ,otrvacna varchar2(80) -- 表外账号名
    ,updatedate date -- 更新日期
    ,acctno varchar2(40) -- 转出账号
    ,otfrozsq varchar2(20) -- 子户冻结流水
    ,pdrifm varchar2(1) -- 利率浮动方式
    ,inputtype varchar2(20) -- 生成来源
    ,bailinterestmethod varchar2(12) -- 保证金账户属性
    ,deposittermtype varchar2(5) -- 保证金账户属性
    ,depositterm number(22) -- 存期期限
    ,bailinterestrate number(24,6) -- 保证金执行（协议）利率
    ,depositbaserate number(24,6) -- 存款基准利率
    ,bailterm varchar2(4) -- 保证金利率档次
    ,bailbalanceamt number(24,6) -- 保证金余额
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
grant select on ${iol_schema}.icms_deposit_apply_info to ${iml_schema};
grant select on ${iol_schema}.icms_deposit_apply_info to ${icl_schema};
grant select on ${iol_schema}.icms_deposit_apply_info to ${idl_schema};
grant select on ${iol_schema}.icms_deposit_apply_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_deposit_apply_info is '解冻保证金申请详情';
comment on column ${iol_schema}.icms_deposit_apply_info.serialno is '申请流水号';
comment on column ${iol_schema}.icms_deposit_apply_info.remake is '追加说明';
comment on column ${iol_schema}.icms_deposit_apply_info.cusname is '客户名称';
comment on column ${iol_schema}.icms_deposit_apply_info.grteac is '保证金帐号';
comment on column ${iol_schema}.icms_deposit_apply_info.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_deposit_apply_info.pdrifv is '浮动值';
comment on column ${iol_schema}.icms_deposit_apply_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_deposit_apply_info.cntrtp is '协议类型1--承兑汇票协议 2–保函合同';
comment on column ${iol_schema}.icms_deposit_apply_info.exchangedate is '交易日期';
comment on column ${iol_schema}.icms_deposit_apply_info.otrvbldn is '表外记账方向';
comment on column ${iol_schema}.icms_deposit_apply_info.crcycd is '币种';
comment on column ${iol_schema}.icms_deposit_apply_info.otrvacno is '表外账号';
comment on column ${iol_schema}.icms_deposit_apply_info.fxfltp is '利率类型（核心crgtrt加）';
comment on column ${iol_schema}.icms_deposit_apply_info.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_deposit_apply_info.hascancel is '是否已撤销Y是N否默认可以为空';
comment on column ${iol_schema}.icms_deposit_apply_info.isopen is '是否释放敞口';
comment on column ${iol_schema}.icms_deposit_apply_info.batchserialno is '批次流水';
comment on column ${iol_schema}.icms_deposit_apply_info.initexchangeserialno is '原交易流水号';
comment on column ${iol_schema}.icms_deposit_apply_info.exchangetime is '交易日期';
comment on column ${iol_schema}.icms_deposit_apply_info.interestrate is '协议利率';
comment on column ${iol_schema}.icms_deposit_apply_info.bailsum is '已缴保证金金额';
comment on column ${iol_schema}.icms_deposit_apply_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_deposit_apply_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_deposit_apply_info.contractno is '合同流水号';
comment on column ${iol_schema}.icms_deposit_apply_info.putoutno is '出账流水号';
comment on column ${iol_schema}.icms_deposit_apply_info.matudt is '到期日期票据到期日';
comment on column ${iol_schema}.icms_deposit_apply_info.subaccount is '子户号';
comment on column ${iol_schema}.icms_deposit_apply_info.exchangeserialno is '交易流水号';
comment on column ${iol_schema}.icms_deposit_apply_info.businesstype is '转出业务类型';
comment on column ${iol_schema}.icms_deposit_apply_info.otsusbtp is '冻结止付方式';
comment on column ${iol_schema}.icms_deposit_apply_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_deposit_apply_info.tranam is '金额';
comment on column ${iol_schema}.icms_deposit_apply_info.exchangestate is '交易状态';
comment on column ${iol_schema}.icms_deposit_apply_info.dataid is '唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号';
comment on column ${iol_schema}.icms_deposit_apply_info.balance is '业务余额';
comment on column ${iol_schema}.icms_deposit_apply_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_deposit_apply_info.grtetp is '保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)';
comment on column ${iol_schema}.icms_deposit_apply_info.putoutdate is '业务起贷日';
comment on column ${iol_schema}.icms_deposit_apply_info.pdrifd is '利率浮动类型';
comment on column ${iol_schema}.icms_deposit_apply_info.isdiscountflag is '是否当前借款人';
comment on column ${iol_schema}.icms_deposit_apply_info.migtflag is '';
comment on column ${iol_schema}.icms_deposit_apply_info.cusid is '客户ID';
comment on column ${iol_schema}.icms_deposit_apply_info.interestmethod is '计息方法';
comment on column ${iol_schema}.icms_deposit_apply_info.maturity is '业务到期日';
comment on column ${iol_schema}.icms_deposit_apply_info.prcsna is '表外摘要';
comment on column ${iol_schema}.icms_deposit_apply_info.acptno is '票据号码此字段针对承兑（若grtetp为2时此字段不能为空）';
comment on column ${iol_schema}.icms_deposit_apply_info.opertp is '操作类型1--建立保证金对应关系 2–追加保证金';
comment on column ${iol_schema}.icms_deposit_apply_info.termcd is '存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年';
comment on column ${iol_schema}.icms_deposit_apply_info.otfrsptp is '冻结止付类型';
comment on column ${iol_schema}.icms_deposit_apply_info.otfzremk is '冻结止付原因';
comment on column ${iol_schema}.icms_deposit_apply_info.initexchangedate is '原交易日期';
comment on column ${iol_schema}.icms_deposit_apply_info.businesssum is '业务金额';
comment on column ${iol_schema}.icms_deposit_apply_info.otrvacna is '表外账号名';
comment on column ${iol_schema}.icms_deposit_apply_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_deposit_apply_info.acctno is '转出账号';
comment on column ${iol_schema}.icms_deposit_apply_info.otfrozsq is '子户冻结流水';
comment on column ${iol_schema}.icms_deposit_apply_info.pdrifm is '利率浮动方式';
comment on column ${iol_schema}.icms_deposit_apply_info.inputtype is '生成来源';
comment on column ${iol_schema}.icms_deposit_apply_info.bailinterestmethod is '保证金账户属性';
comment on column ${iol_schema}.icms_deposit_apply_info.deposittermtype is '保证金账户属性';
comment on column ${iol_schema}.icms_deposit_apply_info.depositterm is '存期期限';
comment on column ${iol_schema}.icms_deposit_apply_info.bailinterestrate is '保证金执行（协议）利率';
comment on column ${iol_schema}.icms_deposit_apply_info.depositbaserate is '存款基准利率';
comment on column ${iol_schema}.icms_deposit_apply_info.bailterm is '保证金利率档次';
comment on column ${iol_schema}.icms_deposit_apply_info.bailbalanceamt is '保证金余额';
comment on column ${iol_schema}.icms_deposit_apply_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_deposit_apply_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_deposit_apply_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_deposit_apply_info.etl_timestamp is 'ETL处理时间戳';
