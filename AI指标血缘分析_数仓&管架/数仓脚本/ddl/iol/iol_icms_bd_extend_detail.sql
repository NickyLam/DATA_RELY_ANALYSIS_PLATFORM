/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bd_extend_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bd_extend_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bd_extend_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bd_extend_detail(
    serialno varchar2(30) -- 借据编号
    ,migtflag varchar2(80) -- 
    ,reselltype varchar2(2) -- 01境内转让、02行内转让、03跨境转让
    ,ztrate number(24,6) -- 转贴现利率
    ,benefitcorpbank varchar2(80) -- 受益人开户行
    ,nextperiodreturninterestdate varchar2(10) -- 下一期还息日期
    ,acceptbankid varchar2(100) -- 承兑行行号
    ,billtype varchar2(10) -- 票据类型
    ,istran varchar2(16) -- 转换
    ,tradeorgid varchar2(40) -- 交易机构
    ,logoutdate varchar2(10) -- (Del)注销日期
    ,openno varchar2(32) -- 开立流水
    ,keyno varchar2(40) -- 票据唯一标识
    ,fixterm number(24,6) -- 周期
    ,acceptinttype varchar2(20) -- 收息类型
    ,eacmprincipal number(24,6) -- 每期扣款额本金利息
    ,fixflag varchar2(1) -- 补登借据标志
    ,surplusphases number(24,6) -- 剩余期数
    ,opendate varchar2(18) -- 开立日期
    ,benefitcorpname varchar2(80) -- 受益人
    ,insum number(24,6) -- 累计归还本金
    ,reinforcechecker varchar2(10) -- 补登复核人
    ,ztacceptbankname varchar2(100) -- 直贴行行名
    ,duebalance number(24,6) -- 暂存借据余额
    ,legal number(24,6) -- 诉讼费
    ,datatype varchar2(10) -- 批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）
    ,littlecreditbatchno varchar2(40) -- 支小再批次包
    ,loantype varchar2(20) -- 贷款类型
    ,transdate varchar2(10) -- 同业综合业务系统交易日期
    ,littlecreditstatus varchar2(40) -- 支小再状态
    ,billno varchar2(50) -- 票据号
    ,flag1 varchar2(20) -- (new)是否1
    ,compensationsum number(24,6) -- 赔付金额
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,ztacceptbankid varchar2(32) -- 直贴行行号
    ,isteachhealth varchar2(1) -- 是否文教健康
    ,benefitcorp varchar2(40) -- (Del)受益人
    ,businessdept varchar2(40) -- 业务部门
    ,aboutbankid2 varchar2(40) -- 受益行行号
    ,advanceflagsum number(24,6) -- 垫款金额
    ,nextperiodreturnprincipaldate varchar2(10) -- 下一期还本日期
    ,nextperiodreturninterestsum number(24,6) -- 下一期还息金额
    ,billkind varchar2(10) -- 票据种类
    ,ictype varchar2(20) -- 计息方式
    ,preinttype varchar2(20) -- 预收息标志
    ,interestinsum number(24,6) -- 累计归还利息
    ,littlecreditbatchenddate varchar2(10) -- 支小再批次到期日
    ,accountcatagory varchar2(40) -- 账户类别(代码:AccountCatagory)
    ,aboutbankname2 varchar2(80) -- 受益行行名
    ,logouttype varchar2(2) -- 注销类型
    ,premiumrate number(24,6) -- 费率
    ,acceptbankname varchar2(200) -- 承兑行行名
    ,littlecreditlapsetime varchar2(10) -- 支小再失效时间
    ,deductdate varchar2(10) -- 扣款日期
    ,logoutno varchar2(32) -- 注销流水
    ,nextperiodreturnprincipalsum number(24,6) -- 下一期还本金额
    ,assetno varchar2(100) -- 资产唯一标识
    ,actualbalance number(24,6) -- 原币余额
    ,actualbusinesssum number(24,6) -- 原币金额
    ,actualcurrency varchar2(18) -- 原币种
    ,exchangerate number(15,8) -- 汇率
    ,ddno varchar2(5) -- 序号（银团贷款）
    ,lender varchar2(100) -- 联行号
    ,objid varchar2(100) -- 同业业务系统OBJID
    ,naccountvalue number(24,6) -- 面值
    ,naccrualinterest number(24,6) -- 应计利息
    ,nbalance number(24,6) -- 账面价值
    ,ninterestadjust number(24,6) -- 利息调整
    ,npvvariation number(24,6) -- 公允价值变动
    ,interexpnum varchar2(64) -- 利息支出费用编号
    ,commexpnum varchar2(64) -- 手续费支出费用编号
    ,sellstatus varchar2(10) -- 卖出状态
    ,overdrafttime date -- 
    ,paymentobject varchar2(32) -- 
    ,purpose varchar2(200) -- 
    ,ftcommission varchar2(32) -- 
    ,agreementid varchar2(50) -- 
    ,isreceivebill varchar2(2) -- 
    ,iscreditrelease varchar2(2) -- 
    ,lastmodified date -- 
    ,oldassetno varchar2(100) -- 
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
grant select on ${iol_schema}.icms_bd_extend_detail to ${iml_schema};
grant select on ${iol_schema}.icms_bd_extend_detail to ${icl_schema};
grant select on ${iol_schema}.icms_bd_extend_detail to ${idl_schema};
grant select on ${iol_schema}.icms_bd_extend_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bd_extend_detail is '非零售借据附表';
comment on column ${iol_schema}.icms_bd_extend_detail.serialno is '借据编号';
comment on column ${iol_schema}.icms_bd_extend_detail.migtflag is '';
comment on column ${iol_schema}.icms_bd_extend_detail.reselltype is '01境内转让、02行内转让、03跨境转让';
comment on column ${iol_schema}.icms_bd_extend_detail.ztrate is '转贴现利率';
comment on column ${iol_schema}.icms_bd_extend_detail.benefitcorpbank is '受益人开户行';
comment on column ${iol_schema}.icms_bd_extend_detail.nextperiodreturninterestdate is '下一期还息日期';
comment on column ${iol_schema}.icms_bd_extend_detail.acceptbankid is '承兑行行号';
comment on column ${iol_schema}.icms_bd_extend_detail.billtype is '票据类型';
comment on column ${iol_schema}.icms_bd_extend_detail.istran is '转换';
comment on column ${iol_schema}.icms_bd_extend_detail.tradeorgid is '交易机构';
comment on column ${iol_schema}.icms_bd_extend_detail.logoutdate is '(Del)注销日期';
comment on column ${iol_schema}.icms_bd_extend_detail.openno is '开立流水';
comment on column ${iol_schema}.icms_bd_extend_detail.keyno is '票据唯一标识';
comment on column ${iol_schema}.icms_bd_extend_detail.fixterm is '周期';
comment on column ${iol_schema}.icms_bd_extend_detail.acceptinttype is '收息类型';
comment on column ${iol_schema}.icms_bd_extend_detail.eacmprincipal is '每期扣款额本金利息';
comment on column ${iol_schema}.icms_bd_extend_detail.fixflag is '补登借据标志';
comment on column ${iol_schema}.icms_bd_extend_detail.surplusphases is '剩余期数';
comment on column ${iol_schema}.icms_bd_extend_detail.opendate is '开立日期';
comment on column ${iol_schema}.icms_bd_extend_detail.benefitcorpname is '受益人';
comment on column ${iol_schema}.icms_bd_extend_detail.insum is '累计归还本金';
comment on column ${iol_schema}.icms_bd_extend_detail.reinforcechecker is '补登复核人';
comment on column ${iol_schema}.icms_bd_extend_detail.ztacceptbankname is '直贴行行名';
comment on column ${iol_schema}.icms_bd_extend_detail.duebalance is '暂存借据余额';
comment on column ${iol_schema}.icms_bd_extend_detail.legal is '诉讼费';
comment on column ${iol_schema}.icms_bd_extend_detail.datatype is '批量数据来源（PJ,票据系统供数LC,理财资管系统供数ZJ,资金系统供数ZH,同业综合业务系统供数）';
comment on column ${iol_schema}.icms_bd_extend_detail.littlecreditbatchno is '支小再批次包';
comment on column ${iol_schema}.icms_bd_extend_detail.loantype is '贷款类型';
comment on column ${iol_schema}.icms_bd_extend_detail.transdate is '同业综合业务系统交易日期';
comment on column ${iol_schema}.icms_bd_extend_detail.littlecreditstatus is '支小再状态';
comment on column ${iol_schema}.icms_bd_extend_detail.billno is '票据号';
comment on column ${iol_schema}.icms_bd_extend_detail.flag1 is '(new)是否1';
comment on column ${iol_schema}.icms_bd_extend_detail.compensationsum is '赔付金额';
comment on column ${iol_schema}.icms_bd_extend_detail.isinuse is '添加维护标志1正常2不维护';
comment on column ${iol_schema}.icms_bd_extend_detail.ztacceptbankid is '直贴行行号';
comment on column ${iol_schema}.icms_bd_extend_detail.isteachhealth is '是否文教健康';
comment on column ${iol_schema}.icms_bd_extend_detail.benefitcorp is '(Del)受益人';
comment on column ${iol_schema}.icms_bd_extend_detail.businessdept is '业务部门';
comment on column ${iol_schema}.icms_bd_extend_detail.aboutbankid2 is '受益行行号';
comment on column ${iol_schema}.icms_bd_extend_detail.advanceflagsum is '垫款金额';
comment on column ${iol_schema}.icms_bd_extend_detail.nextperiodreturnprincipaldate is '下一期还本日期';
comment on column ${iol_schema}.icms_bd_extend_detail.nextperiodreturninterestsum is '下一期还息金额';
comment on column ${iol_schema}.icms_bd_extend_detail.billkind is '票据种类';
comment on column ${iol_schema}.icms_bd_extend_detail.ictype is '计息方式';
comment on column ${iol_schema}.icms_bd_extend_detail.preinttype is '预收息标志';
comment on column ${iol_schema}.icms_bd_extend_detail.interestinsum is '累计归还利息';
comment on column ${iol_schema}.icms_bd_extend_detail.littlecreditbatchenddate is '支小再批次到期日';
comment on column ${iol_schema}.icms_bd_extend_detail.accountcatagory is '账户类别(代码:AccountCatagory)';
comment on column ${iol_schema}.icms_bd_extend_detail.aboutbankname2 is '受益行行名';
comment on column ${iol_schema}.icms_bd_extend_detail.logouttype is '注销类型';
comment on column ${iol_schema}.icms_bd_extend_detail.premiumrate is '费率';
comment on column ${iol_schema}.icms_bd_extend_detail.acceptbankname is '承兑行行名';
comment on column ${iol_schema}.icms_bd_extend_detail.littlecreditlapsetime is '支小再失效时间';
comment on column ${iol_schema}.icms_bd_extend_detail.deductdate is '扣款日期';
comment on column ${iol_schema}.icms_bd_extend_detail.logoutno is '注销流水';
comment on column ${iol_schema}.icms_bd_extend_detail.nextperiodreturnprincipalsum is '下一期还本金额';
comment on column ${iol_schema}.icms_bd_extend_detail.assetno is '资产唯一标识';
comment on column ${iol_schema}.icms_bd_extend_detail.actualbalance is '原币余额';
comment on column ${iol_schema}.icms_bd_extend_detail.actualbusinesssum is '原币金额';
comment on column ${iol_schema}.icms_bd_extend_detail.actualcurrency is '原币种';
comment on column ${iol_schema}.icms_bd_extend_detail.exchangerate is '汇率';
comment on column ${iol_schema}.icms_bd_extend_detail.ddno is '序号（银团贷款）';
comment on column ${iol_schema}.icms_bd_extend_detail.lender is '联行号';
comment on column ${iol_schema}.icms_bd_extend_detail.objid is '同业业务系统OBJID';
comment on column ${iol_schema}.icms_bd_extend_detail.naccountvalue is '面值';
comment on column ${iol_schema}.icms_bd_extend_detail.naccrualinterest is '应计利息';
comment on column ${iol_schema}.icms_bd_extend_detail.nbalance is '账面价值';
comment on column ${iol_schema}.icms_bd_extend_detail.ninterestadjust is '利息调整';
comment on column ${iol_schema}.icms_bd_extend_detail.npvvariation is '公允价值变动';
comment on column ${iol_schema}.icms_bd_extend_detail.interexpnum is '利息支出费用编号';
comment on column ${iol_schema}.icms_bd_extend_detail.commexpnum is '手续费支出费用编号';
comment on column ${iol_schema}.icms_bd_extend_detail.sellstatus is '卖出状态';
comment on column ${iol_schema}.icms_bd_extend_detail.overdrafttime is '';
comment on column ${iol_schema}.icms_bd_extend_detail.paymentobject is '';
comment on column ${iol_schema}.icms_bd_extend_detail.purpose is '';
comment on column ${iol_schema}.icms_bd_extend_detail.ftcommission is '';
comment on column ${iol_schema}.icms_bd_extend_detail.agreementid is '';
comment on column ${iol_schema}.icms_bd_extend_detail.isreceivebill is '';
comment on column ${iol_schema}.icms_bd_extend_detail.iscreditrelease is '';
comment on column ${iol_schema}.icms_bd_extend_detail.lastmodified is '';
comment on column ${iol_schema}.icms_bd_extend_detail.oldassetno is '';
comment on column ${iol_schema}.icms_bd_extend_detail.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bd_extend_detail.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bd_extend_detail.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bd_extend_detail.etl_timestamp is 'ETL处理时间戳';
