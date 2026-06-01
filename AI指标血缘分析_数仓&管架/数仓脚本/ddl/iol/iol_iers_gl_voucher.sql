/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_gl_voucher
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_gl_voucher
whenever sqlerror continue none;
drop table ${iol_schema}.iers_gl_voucher purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_voucher(
    addclass varchar2(90) -- 增加接口类
    ,adjustperiod varchar2(5) -- 调整期间
    ,approver varchar2(30) -- 
    ,attachment number(38,0) -- 附单据数
    ,billmaker varchar2(30) -- 
    ,checkeddate varchar2(29) -- 审核日期
    ,contrastflag number(38,0) -- 
    ,convertflag varchar2(2) -- 折算凭证
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,deleteclass varchar2(90) -- 删除接口类
    ,detailmodflag varchar2(2) -- 分录增删标志
    ,discardflag varchar2(2) -- 作废标志
    ,dr number(10,0) -- 删除标志
    ,errmessage varchar2(90) -- 错误信息
    ,errmessageh varchar2(135) -- 历史错误信息
    ,explanation varchar2(3000) -- 摘要
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
    ,isdifflag varchar2(2) -- 差异凭证
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,modifyclass varchar2(90) -- 修改接口类
    ,modifyflag varchar2(30) -- 修改标志
    ,num number(38,0) -- 凭证编码
    ,offervoucher varchar2(30) -- 冲销凭证
    ,period varchar2(3) -- 会计期间
    ,pk_accountingbook varchar2(30) -- 核算账簿
    ,pk_casher varchar2(30) -- 出纳
    ,pk_checked varchar2(30) -- 审核人
    ,pk_group varchar2(30) -- 所属集团
    ,pk_manager varchar2(30) -- 记账人
    ,pk_org varchar2(30) -- 财务组织
    ,pk_org_v varchar2(30) -- 财务组织版本
    ,pk_prepared varchar2(30) -- 制单人
    ,pk_setofbook varchar2(30) -- 账簿类型
    ,pk_sourcepk varchar2(30) -- 折算来源凭证
    ,pk_system varchar2(30) -- 制单系统
    ,pk_voucher varchar2(30) -- 凭证主键
    ,pk_vouchertype varchar2(30) -- 凭证类别
    ,preaccountflag varchar2(2) -- 提前关账科目
    ,prepareddate varchar2(29) -- 制单日期
    ,signdate varchar2(29) -- 签字日期
    ,signflag varchar2(2) -- 签字标志
    ,tallydate varchar2(29) -- 记账日期
    ,tempsaveflag varchar2(2) -- 暂存标志
    ,totalcredit number(28,8) -- 贷方合计
    ,totalcreditglobal number(28,8) -- 全局贷方合计
    ,totalcreditgroup number(28,8) -- 集团贷方合计
    ,totaldebit number(28,8) -- 借方合计
    ,totaldebitglobal number(28,8) -- 全局借方合计
    ,totaldebitgroup number(28,8) -- 集团借方合计
    ,ts varchar2(29) -- 时间戳
    ,voucherkind number(38,0) -- 凭证类型
    ,year varchar2(6) -- 会计年度
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
grant select on ${iol_schema}.iers_gl_voucher to ${iml_schema};
grant select on ${iol_schema}.iers_gl_voucher to ${icl_schema};
grant select on ${iol_schema}.iers_gl_voucher to ${idl_schema};
grant select on ${iol_schema}.iers_gl_voucher to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_gl_voucher is '凭证表';
comment on column ${iol_schema}.iers_gl_voucher.addclass is '增加接口类';
comment on column ${iol_schema}.iers_gl_voucher.adjustperiod is '调整期间';
comment on column ${iol_schema}.iers_gl_voucher.approver is '';
comment on column ${iol_schema}.iers_gl_voucher.attachment is '附单据数';
comment on column ${iol_schema}.iers_gl_voucher.billmaker is '';
comment on column ${iol_schema}.iers_gl_voucher.checkeddate is '审核日期';
comment on column ${iol_schema}.iers_gl_voucher.contrastflag is '';
comment on column ${iol_schema}.iers_gl_voucher.convertflag is '折算凭证';
comment on column ${iol_schema}.iers_gl_voucher.creationtime is '创建时间';
comment on column ${iol_schema}.iers_gl_voucher.creator is '创建人';
comment on column ${iol_schema}.iers_gl_voucher.deleteclass is '删除接口类';
comment on column ${iol_schema}.iers_gl_voucher.detailmodflag is '分录增删标志';
comment on column ${iol_schema}.iers_gl_voucher.discardflag is '作废标志';
comment on column ${iol_schema}.iers_gl_voucher.dr is '删除标志';
comment on column ${iol_schema}.iers_gl_voucher.errmessage is '错误信息';
comment on column ${iol_schema}.iers_gl_voucher.errmessageh is '历史错误信息';
comment on column ${iol_schema}.iers_gl_voucher.explanation is '摘要';
comment on column ${iol_schema}.iers_gl_voucher.free1 is '预留字段1';
comment on column ${iol_schema}.iers_gl_voucher.free10 is '预留字段10';
comment on column ${iol_schema}.iers_gl_voucher.free2 is '预留字段2';
comment on column ${iol_schema}.iers_gl_voucher.free3 is '预留字段3';
comment on column ${iol_schema}.iers_gl_voucher.free4 is '预留字段4';
comment on column ${iol_schema}.iers_gl_voucher.free5 is '预留字段5';
comment on column ${iol_schema}.iers_gl_voucher.free6 is '预留字段6';
comment on column ${iol_schema}.iers_gl_voucher.free7 is '预留字段7';
comment on column ${iol_schema}.iers_gl_voucher.free8 is '预留字段8';
comment on column ${iol_schema}.iers_gl_voucher.free9 is '预留字段9';
comment on column ${iol_schema}.iers_gl_voucher.isdifflag is '差异凭证';
comment on column ${iol_schema}.iers_gl_voucher.modifiedtime is '修改时间';
comment on column ${iol_schema}.iers_gl_voucher.modifier is '修改人';
comment on column ${iol_schema}.iers_gl_voucher.modifyclass is '修改接口类';
comment on column ${iol_schema}.iers_gl_voucher.modifyflag is '修改标志';
comment on column ${iol_schema}.iers_gl_voucher.num is '凭证编码';
comment on column ${iol_schema}.iers_gl_voucher.offervoucher is '冲销凭证';
comment on column ${iol_schema}.iers_gl_voucher.period is '会计期间';
comment on column ${iol_schema}.iers_gl_voucher.pk_accountingbook is '核算账簿';
comment on column ${iol_schema}.iers_gl_voucher.pk_casher is '出纳';
comment on column ${iol_schema}.iers_gl_voucher.pk_checked is '审核人';
comment on column ${iol_schema}.iers_gl_voucher.pk_group is '所属集团';
comment on column ${iol_schema}.iers_gl_voucher.pk_manager is '记账人';
comment on column ${iol_schema}.iers_gl_voucher.pk_org is '财务组织';
comment on column ${iol_schema}.iers_gl_voucher.pk_org_v is '财务组织版本';
comment on column ${iol_schema}.iers_gl_voucher.pk_prepared is '制单人';
comment on column ${iol_schema}.iers_gl_voucher.pk_setofbook is '账簿类型';
comment on column ${iol_schema}.iers_gl_voucher.pk_sourcepk is '折算来源凭证';
comment on column ${iol_schema}.iers_gl_voucher.pk_system is '制单系统';
comment on column ${iol_schema}.iers_gl_voucher.pk_voucher is '凭证主键';
comment on column ${iol_schema}.iers_gl_voucher.pk_vouchertype is '凭证类别';
comment on column ${iol_schema}.iers_gl_voucher.preaccountflag is '提前关账科目';
comment on column ${iol_schema}.iers_gl_voucher.prepareddate is '制单日期';
comment on column ${iol_schema}.iers_gl_voucher.signdate is '签字日期';
comment on column ${iol_schema}.iers_gl_voucher.signflag is '签字标志';
comment on column ${iol_schema}.iers_gl_voucher.tallydate is '记账日期';
comment on column ${iol_schema}.iers_gl_voucher.tempsaveflag is '暂存标志';
comment on column ${iol_schema}.iers_gl_voucher.totalcredit is '贷方合计';
comment on column ${iol_schema}.iers_gl_voucher.totalcreditglobal is '全局贷方合计';
comment on column ${iol_schema}.iers_gl_voucher.totalcreditgroup is '集团贷方合计';
comment on column ${iol_schema}.iers_gl_voucher.totaldebit is '借方合计';
comment on column ${iol_schema}.iers_gl_voucher.totaldebitglobal is '全局借方合计';
comment on column ${iol_schema}.iers_gl_voucher.totaldebitgroup is '集团借方合计';
comment on column ${iol_schema}.iers_gl_voucher.ts is '时间戳';
comment on column ${iol_schema}.iers_gl_voucher.voucherkind is '凭证类型';
comment on column ${iol_schema}.iers_gl_voucher.year is '会计年度';
comment on column ${iol_schema}.iers_gl_voucher.start_dt is '开始时间';
comment on column ${iol_schema}.iers_gl_voucher.end_dt is '结束时间';
comment on column ${iol_schema}.iers_gl_voucher.id_mark is '增删标志';
comment on column ${iol_schema}.iers_gl_voucher.etl_timestamp is 'ETL处理时间戳';
