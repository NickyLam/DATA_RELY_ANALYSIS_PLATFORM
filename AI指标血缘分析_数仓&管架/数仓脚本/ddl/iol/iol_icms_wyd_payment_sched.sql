/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_payment_sched
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_payment_sched
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_payment_sched purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_payment_sched(
    datadt varchar2(10) -- 数据日期
    ,lendingref varchar2(64) -- 借据号
    ,orgid varchar2(20) -- 机构号
    ,term varchar2(10) -- 当前期数
    ,pmaturitydate varchar2(10) -- 当期本金到期日期
    ,prepay number(20,4) -- 当期应还本金
    ,prepayact number(20,4) -- 当期实还本金
    ,imaturitydate varchar2(10) -- 当期利息到期日期
    ,irepay number(20,4) -- 当期应还总利息
    ,irepayact number(20,4) -- 当期实还利息
    ,poverdueamt number(20,4) -- 逾期金额
    ,remainingmaturitym number(5) -- 剩余期限-月
    ,remainingmaturityd number(5) -- 剩余期限_日
    ,remainingmaturitymi number(5) -- 下一利息收付剩余期限_月
    ,remainingmaturitydi number(5) -- 下一利息收付剩余期限_日
    ,scheduleaction varchar2(10) -- 还款计划操作动作
    ,insurancepaymentflag varchar2(1) -- 保险代偿标志
    ,insurancepaymentdate varchar2(10) -- 保险代偿日期
    ,intedate varchar2(10) -- 顺延日期
    ,prepayadv number(15,2) -- 本金提前还款金额
    ,delayinterest number(20,4) -- 递延利息
    ,payinterestamt number(20,4) -- 应还利息
    ,payprincipalpenaltyamt number(20,4) -- 应还本金罚息
    ,payinterestpenaltyamt number(20,4) -- 应还利息罚息
    ,actualpayinterestamt number(20,4) -- 实还利息
    ,actualpayprincipalpenaltyamt number(20,4) -- 实还本金罚息
    ,actualpayinterestpenaltyamt number(20,4) -- 实还利息罚息
    ,pstatus varchar2(2) -- 本金状态
    ,dstatus varchar2(2) -- 本期状态
    ,finishdate varchar2(10) -- 当期结清日期
    ,waiveprincipalamt number(20,4) -- 减免本金
    ,waiveinterestamt number(20,4) -- 减免利息
    ,waivepenaltyamt number(20,4) -- 减免罚息
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,prinovddate varchar2(10) -- 本金转逾期日期
    ,intovddate varchar2(10) -- 利息转逾期日期
    ,capitaloverdays varchar2(20) -- 本金逾期天数
    ,intovddays varchar2(20) -- 利息逾期天数
    ,dateofvalue varchar2(10) -- 起息日期
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
grant select on ${iol_schema}.icms_wyd_payment_sched to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_payment_sched to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_payment_sched to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_payment_sched to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_payment_sched is '还款计划文件';
comment on column ${iol_schema}.icms_wyd_payment_sched.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_payment_sched.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_payment_sched.term is '当前期数';
comment on column ${iol_schema}.icms_wyd_payment_sched.pmaturitydate is '当期本金到期日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.prepay is '当期应还本金';
comment on column ${iol_schema}.icms_wyd_payment_sched.prepayact is '当期实还本金';
comment on column ${iol_schema}.icms_wyd_payment_sched.imaturitydate is '当期利息到期日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.irepay is '当期应还总利息';
comment on column ${iol_schema}.icms_wyd_payment_sched.irepayact is '当期实还利息';
comment on column ${iol_schema}.icms_wyd_payment_sched.poverdueamt is '逾期金额';
comment on column ${iol_schema}.icms_wyd_payment_sched.remainingmaturitym is '剩余期限-月';
comment on column ${iol_schema}.icms_wyd_payment_sched.remainingmaturityd is '剩余期限_日';
comment on column ${iol_schema}.icms_wyd_payment_sched.remainingmaturitymi is '下一利息收付剩余期限_月';
comment on column ${iol_schema}.icms_wyd_payment_sched.remainingmaturitydi is '下一利息收付剩余期限_日';
comment on column ${iol_schema}.icms_wyd_payment_sched.scheduleaction is '还款计划操作动作';
comment on column ${iol_schema}.icms_wyd_payment_sched.insurancepaymentflag is '保险代偿标志';
comment on column ${iol_schema}.icms_wyd_payment_sched.insurancepaymentdate is '保险代偿日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.intedate is '顺延日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.prepayadv is '本金提前还款金额';
comment on column ${iol_schema}.icms_wyd_payment_sched.delayinterest is '递延利息';
comment on column ${iol_schema}.icms_wyd_payment_sched.payinterestamt is '应还利息';
comment on column ${iol_schema}.icms_wyd_payment_sched.payprincipalpenaltyamt is '应还本金罚息';
comment on column ${iol_schema}.icms_wyd_payment_sched.payinterestpenaltyamt is '应还利息罚息';
comment on column ${iol_schema}.icms_wyd_payment_sched.actualpayinterestamt is '实还利息';
comment on column ${iol_schema}.icms_wyd_payment_sched.actualpayprincipalpenaltyamt is '实还本金罚息';
comment on column ${iol_schema}.icms_wyd_payment_sched.actualpayinterestpenaltyamt is '实还利息罚息';
comment on column ${iol_schema}.icms_wyd_payment_sched.pstatus is '本金状态';
comment on column ${iol_schema}.icms_wyd_payment_sched.dstatus is '本期状态';
comment on column ${iol_schema}.icms_wyd_payment_sched.finishdate is '当期结清日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.waiveprincipalamt is '减免本金';
comment on column ${iol_schema}.icms_wyd_payment_sched.waiveinterestamt is '减免利息';
comment on column ${iol_schema}.icms_wyd_payment_sched.waivepenaltyamt is '减免罚息';
comment on column ${iol_schema}.icms_wyd_payment_sched.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_payment_sched.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_payment_sched.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_payment_sched.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_payment_sched.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_payment_sched.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_payment_sched.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_payment_sched.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_payment_sched.prinovddate is '本金转逾期日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.intovddate is '利息转逾期日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.capitaloverdays is '本金逾期天数';
comment on column ${iol_schema}.icms_wyd_payment_sched.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_wyd_payment_sched.dateofvalue is '起息日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_payment_sched.etl_timestamp is 'ETL处理时间戳';
