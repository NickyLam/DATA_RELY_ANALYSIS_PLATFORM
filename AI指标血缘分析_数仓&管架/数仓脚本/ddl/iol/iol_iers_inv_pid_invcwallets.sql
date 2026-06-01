/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_inv_pid_invcwallets
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_inv_pid_invcwallets
whenever sqlerror continue none;
drop table ${iol_schema}.iers_inv_pid_invcwallets purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_inv_pid_invcwallets(
    pk_invcwallets varchar2(4000) -- 
    ,dr number(10,0) -- 
    ,ts varchar2(29) -- 
    ,creator varchar2(60) -- 录入人
    ,creationtime varchar2(900) -- 采集日期
    ,invctype varchar2(150) -- 发票类型
    ,srcsystem varchar2(150) -- 来源系统
    ,collectmode varchar2(150) -- 采集方式
    ,totallev number(28,8) -- 含税金额合计
    ,totalamt number(28,8) -- 不含税金额合计
    ,taxrate varchar2(150) -- 税率
    ,totaltax number(28,8) -- 税额合计
    ,totallevbal number(28,8) -- 含税金额合计余额
    ,totaltaxbal number(28,8) -- 发票税额余额
    ,bxstate varchar2(150) -- 报销状态
    ,checkstate varchar2(15) -- 查验状态
    ,sealspecial varchar2(3000) -- 发票专用章
    ,sealprod varchar2(3000) -- 发票监制章
    ,invcurl varchar2(3000) -- 发票地址
    ,filename varchar2(1500) -- 附件名
    ,invcdate varchar2(900) -- 开票日期
    ,salename varchar2(150) -- 销方名称
    ,saletaxno varchar2(90) -- 销方税号
    ,saleaddress varchar2(1500) -- 销方地址、电话
    ,salebank varchar2(1500) -- 销方开户行及账号
    ,buyname varchar2(150) -- 购方名称
    ,buytaxno varchar2(90) -- 购方税号
    ,buyaddress varchar2(1500) -- 购方地址、电话
    ,buybank varchar2(1500) -- 购方开户行及账号
    ,invcode varchar2(60) -- 发票代码
    ,invcno varchar2(150) -- 发票号码
    ,chkcode varchar2(150) -- 校验码
    ,machcode varchar2(150) -- 机器编码
    ,drawer varchar2(150) -- 开票人
    ,receiptor varchar2(150) -- 收款人
    ,reviewer varchar2(150) -- 复核人
    ,remark varchar2(1500) -- 备注
    ,custname varchar2(150) -- 旅客姓名
    ,custidno varchar2(90) -- 身份证号码
    ,fromaddr varchar2(900) -- 出发地
    ,toaddr varchar2(900) -- 目的地
    ,tripcode varchar2(150) -- 航班号/车次
    ,startime varchar2(150) -- 时间
    ,endtime varchar2(150) -- 结束时间
    ,cca_devfund number(28,8) -- 民航发展基金
    ,fuelsrchrg number(28,8) -- 燃油附加费
    ,otherfees number(28,8) -- 其他税费
    ,insurance number(28,8) -- 保险费
    ,seatno varchar2(150) -- 座位
    ,seatrank varchar2(60) -- 座位等级
    ,price number(28,8) -- 单价
    ,mileage number(28,8) -- 里程数
    ,transfertax number(28,8) -- 转出税额
    ,amt number(28,8) -- 票价
    ,airstate varchar2(150) -- 票号状态
    ,category varchar2(150) -- 种类
    ,ticketbagid varchar2(150) -- 票袋主键
    ,accountno varchar2(150) -- 对账单号
    ,billperiod varchar2(150) -- 账期
    ,doubtstatus varchar2(150) -- 疑票状态(0 已放行/1 未放行/2 禁止)
    ,doubtreasons varchar2(1500) -- 疑票原因
    ,billtype varchar2(150) -- 票种类型
    ,taxperiod varchar2(150) -- 税款所属期
    ,tick varchar2(15) -- 是否勾选
    ,tickdate varchar2(900) -- 勾选日期
    ,tickmethod varchar2(15) -- 勾选方式
    ,authstatus varchar2(15) -- 认证状态
    ,authfailurereason varchar2(1500) -- 认证失败原因
    ,authdate varchar2(900) -- 认证日期
    ,effectivededuction number(28,8) -- 有效抵扣额
    ,def2 varchar2(900) -- 
    ,def3 varchar2(900) -- 
    ,def4 varchar2(900) -- 
    ,def5 varchar2(900) -- 
    ,def6 varchar2(900) -- 
    ,def7 varchar2(900) -- 
    ,def8 varchar2(900) -- 
    ,def9 varchar2(900) -- 
    ,def10 varchar2(900) -- 
    ,def11 varchar2(900) -- 
    ,def12 varchar2(900) -- 
    ,def13 varchar2(900) -- 
    ,def14 varchar2(900) -- 
    ,def15 varchar2(900) -- 
    ,def16 varchar2(900) -- 
    ,def17 varchar2(900) -- 
    ,def18 varchar2(900) -- 
    ,def19 varchar2(900) -- 
    ,def20 varchar2(900) -- 
    ,invcid varchar2(900) -- 提供友报账专用主键
    ,createtime varchar2(900) -- 创建时间
    ,updatetime varchar2(900) -- 修改时间
    ,invcnoprint varchar2(900) -- 打印发票号码
    ,pk_org varchar2(900) -- 组织编码
    ,carrystatus varchar2(15) -- 结转状态
    ,carrydate varchar2(900) -- 结转日期
    ,carryno varchar2(90) -- 结转凭证号
    ,tickresult varchar2(300) -- 勾选结果
    ,authresult varchar2(300) -- 认证结果
    ,castatus varchar2(15) -- 记账状态
    ,authmethod varchar2(150) -- 认证方式
    ,tagid varchar2(900) -- 
    ,reimbursementtype varchar2(30) -- 报销方式(0 整单报销 1明细报销 2余额报销)
    ,reimbursementbalance number(28,8) -- 报销余额
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
grant select on ${iol_schema}.iers_inv_pid_invcwallets to ${iml_schema};
grant select on ${iol_schema}.iers_inv_pid_invcwallets to ${icl_schema};
grant select on ${iol_schema}.iers_inv_pid_invcwallets to ${idl_schema};
grant select on ${iol_schema}.iers_inv_pid_invcwallets to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_inv_pid_invcwallets is '发票表';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.pk_invcwallets is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.dr is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.ts is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.creator is '录入人';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.creationtime is '采集日期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invctype is '发票类型';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.srcsystem is '来源系统';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.collectmode is '采集方式';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.totallev is '含税金额合计';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.totalamt is '不含税金额合计';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.taxrate is '税率';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.totaltax is '税额合计';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.totallevbal is '含税金额合计余额';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.totaltaxbal is '发票税额余额';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.bxstate is '报销状态';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.checkstate is '查验状态';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.sealspecial is '发票专用章';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.sealprod is '发票监制章';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invcurl is '发票地址';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.filename is '附件名';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invcdate is '开票日期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.salename is '销方名称';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.saletaxno is '销方税号';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.saleaddress is '销方地址、电话';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.salebank is '销方开户行及账号';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.buyname is '购方名称';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.buytaxno is '购方税号';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.buyaddress is '购方地址、电话';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.buybank is '购方开户行及账号';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invcode is '发票代码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invcno is '发票号码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.chkcode is '校验码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.machcode is '机器编码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.drawer is '开票人';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.receiptor is '收款人';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.reviewer is '复核人';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.remark is '备注';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.custname is '旅客姓名';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.custidno is '身份证号码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.fromaddr is '出发地';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.toaddr is '目的地';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.tripcode is '航班号/车次';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.startime is '时间';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.endtime is '结束时间';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.cca_devfund is '民航发展基金';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.fuelsrchrg is '燃油附加费';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.otherfees is '其他税费';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.insurance is '保险费';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.seatno is '座位';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.seatrank is '座位等级';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.price is '单价';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.mileage is '里程数';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.transfertax is '转出税额';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.amt is '票价';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.airstate is '票号状态';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.category is '种类';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.ticketbagid is '票袋主键';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.accountno is '对账单号';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.billperiod is '账期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.doubtstatus is '疑票状态(0 已放行/1 未放行/2 禁止)';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.doubtreasons is '疑票原因';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.billtype is '票种类型';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.taxperiod is '税款所属期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.tick is '是否勾选';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.tickdate is '勾选日期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.tickmethod is '勾选方式';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.authstatus is '认证状态';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.authfailurereason is '认证失败原因';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.authdate is '认证日期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.effectivededuction is '有效抵扣额';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def2 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def3 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def4 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def5 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def6 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def7 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def8 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def9 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def10 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def11 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def12 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def13 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def14 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def15 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def16 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def17 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def18 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def19 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.def20 is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invcid is '提供友报账专用主键';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.createtime is '创建时间';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.updatetime is '修改时间';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.invcnoprint is '打印发票号码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.pk_org is '组织编码';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.carrystatus is '结转状态';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.carrydate is '结转日期';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.carryno is '结转凭证号';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.tickresult is '勾选结果';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.authresult is '认证结果';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.castatus is '记账状态';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.authmethod is '认证方式';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.tagid is '';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.reimbursementtype is '报销方式(0 整单报销 1明细报销 2余额报销)';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.reimbursementbalance is '报销余额';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.start_dt is '开始时间';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.end_dt is '结束时间';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.id_mark is '增删标志';
comment on column ${iol_schema}.iers_inv_pid_invcwallets.etl_timestamp is 'ETL处理时间戳';
