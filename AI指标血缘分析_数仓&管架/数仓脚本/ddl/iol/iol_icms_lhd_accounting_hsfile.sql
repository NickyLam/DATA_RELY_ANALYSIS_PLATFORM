/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhd_accounting_hsfile
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhd_accounting_hsfile
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhd_accounting_hsfile purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhd_accounting_hsfile(
    soursq varchar2(64) -- 源系统流水号,按照该流水表内借贷平衡
    ,vchrsq varchar2(20) -- 传票序号,流水号+序号能对应到唯一的一条流水数据
    ,assis9 varchar2(30) -- 辅助核算9,不启用，传空值
    ,tranbr varchar2(16) -- 交易机构编号,一个交易流水的“交易机构”只能有一个
    ,assis0 varchar2(30) -- 辅助核算0,渠道号，若无，则提供默认值
    ,chrex1 varchar2(30) -- 授权用户,营运复核岗-域用户编号
    ,itemcd varchar2(30) -- 科目编号,按照新科目提供
    ,tranam number(20,2) -- 交易金额,支持负数
    ,acctno varchar2(30) -- 协议编号,同业系统不提供
    ,sourdt varchar2(8) -- 源系统日期,YYYYMMHH
    ,prcscd varchar2(20) -- 交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送
    ,custcd varchar2(30) -- 客户号,为了传给增值税系统开具增值税发票
    ,assis2 varchar2(30) -- 辅助核算2,不启用，传空值
    ,chrex3 varchar2(64) -- 冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段
    ,amntcd varchar2(1) -- 借贷方向,借：D贷：C
    ,assis1 varchar2(30) -- 辅助核算1,
    ,assis4 varchar2(30) -- 辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税
    ,bsnssq varchar2(50) -- 全局流水号,指全局流水，新一代统一规划，按照数据标准提供。
    ,assis3 varchar2(30) -- 辅助核算3,不启用，传空值
    ,assis7 varchar2(30) -- 辅助核算7,不启用，传空值
    ,prducd varchar2(30) -- 产品,即可售产品核心产品工厂统一的编码
    ,chrex0 varchar2(30) -- 交易用户,营运经办岗-域用户编号
    ,assis8 varchar2(16) -- 辅助核算8,不启用，传空值
    ,crcycd varchar2(3) -- 币种,3位字母币种，人民币：CNY
    ,assis5 varchar2(30) -- 辅助核算5,不启用，传空值
    ,datex0 varchar2(30) -- 交易时间,记账时间HHMMSS
    ,sourst varchar2(30) -- 系统代号，外围系统代号
    ,acctbr varchar2(16) -- 账务机构编号,客户的开户机构或者核算机构
    ,smrytx varchar2(400) -- 摘要,
    ,taxam number(20,2) -- 税额,对于同业系统，为适配金融商品转让税则对应的税额
    ,chrex4 varchar2(30) -- 冲抹标记,0-非冲抹账务1-冲抹账务
    ,assis6 varchar2(30) -- 辅助核算6,不启用，传空值
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
grant select on ${iol_schema}.icms_lhd_accounting_hsfile to ${iml_schema};
grant select on ${iol_schema}.icms_lhd_accounting_hsfile to ${icl_schema};
grant select on ${iol_schema}.icms_lhd_accounting_hsfile to ${idl_schema};
grant select on ${iol_schema}.icms_lhd_accounting_hsfile to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhd_accounting_hsfile is '联合贷推送核心会记流水文件数据表';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.soursq is '源系统流水号,按照该流水表内借贷平衡';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.vchrsq is '传票序号,流水号+序号能对应到唯一的一条流水数据';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis9 is '辅助核算9,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.tranbr is '交易机构编号,一个交易流水的“交易机构”只能有一个';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis0 is '辅助核算0,渠道号，若无，则提供默认值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.chrex1 is '授权用户,营运复核岗-域用户编号';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.itemcd is '科目编号,按照新科目提供';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.tranam is '交易金额,支持负数';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.acctno is '协议编号,同业系统不提供';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.sourdt is '源系统日期,YYYYMMHH';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.prcscd is '交易码,处理码，用以价税分离使用，若存在需要做价税分离需要传送';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.custcd is '客户号,为了传给增值税系统开具增值税发票';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis2 is '辅助核算2,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.chrex3 is '冲抹原交易流水号,同业系统无法提供，核算根据冲抹标记生成冲销分录，该字段为本身GLI_VCHR的字段';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.amntcd is '借贷方向,借：D贷：C';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis1 is '辅助核算1,';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis4 is '辅助核算4,对应的收入科目是否免税标识：免税、应税、不征税';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.bsnssq is '全局流水号,指全局流水，新一代统一规划，按照数据标准提供。';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis3 is '辅助核算3,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis7 is '辅助核算7,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.prducd is '产品,即可售产品核心产品工厂统一的编码';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.chrex0 is '交易用户,营运经办岗-域用户编号';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis8 is '辅助核算8,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.crcycd is '币种,3位字母币种，人民币：CNY';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis5 is '辅助核算5,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.datex0 is '交易时间,记账时间HHMMSS';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.sourst is '系统代号，外围系统代号';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.acctbr is '账务机构编号,客户的开户机构或者核算机构';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.smrytx is '摘要,';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.taxam is '税额,对于同业系统，为适配金融商品转让税则对应的税额';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.chrex4 is '冲抹标记,0-非冲抹账务1-冲抹账务';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.assis6 is '辅助核算6,不启用，传空值';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhd_accounting_hsfile.etl_timestamp is 'ETL处理时间戳';
