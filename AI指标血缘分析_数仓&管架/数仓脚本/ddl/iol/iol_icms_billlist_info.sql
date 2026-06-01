/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_billlist_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_billlist_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_billlist_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_billlist_info(
    batchno varchar2(40) -- 批次号
    ,contractno varchar2(40) -- 协议编号
    ,keyno varchar2(40) -- 单笔票据唯一标示
    ,discountsum number(18,6) -- 贴现利息
    ,discountdate date -- 贴现日期
    ,draweracct1name varchar2(150) -- 出票人开户行
    ,isbas varchar2(1) -- 是否可转让
    ,duedate date -- 到期日
    ,payee varchar2(100) -- 收款人户名
    ,purchaserpercent number(24,6) -- 买方付息比例(贴现方式为协议付息才有效)
    ,updatedate date -- 更新日期
    ,draweracctname varchar2(200) -- 贴现客户账户开户行号
    ,acptdate date -- 出票日
    ,drawercustomer varchar2(200) -- 开票人户名
    ,manualpay number(24,6) -- 工本费
    ,othertxbalance number(24,6) -- 第三方付息金额
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,currency varchar2(10) -- 币种
    ,guaracctno varchar2(40) -- 保证金账户
    ,paysum number(24,6) -- 手续费
    ,czflag varchar2(1) -- 冲账标志
    ,inputdate date -- 录入时间
    ,buybenddate date -- 约定赎回日
    ,acceptorbankname varchar2(180) -- 承兑人开户行名称
    ,afeerate number(24,6) -- 贴现利率
    ,customername varchar2(200) -- 客户名称
    ,guarterm varchar2(10) -- 保证金存期
    ,otherdraweracctno varchar2(40) -- 第三方付息账户
    ,isonline varchar2(10) -- 是否线上清算
    ,inputorgid varchar2(12) -- 录入机构
    ,buyenddate date -- 赎回截止日
    ,putoutorgid varchar2(32) -- 放款机构编号
    ,draweracctbankname varchar2(128) -- 贴现客户账户开户行名
    ,updateuserid varchar2(8) -- 更新人
    ,payeeacctname varchar2(150) -- 收款人开户行
    ,guarsum number(24,6) -- 保证金金额
    ,businesstype varchar2(20) -- 交易类型
    ,draweracctno1 varchar2(32) -- 出票人账号
    ,inputuserid varchar2(8) -- 录入人
    ,customerid varchar2(21) -- 客户号
    ,discountway varchar2(2) -- 贴现方式
    ,billclass varchar2(16) -- 票据性质
    ,acptdate2 date -- 承兑日
    ,interestday number(22) -- 计息天数
    ,isbecustody varchar2(1) -- 是否代保管
    ,acceptorbankno varchar2(12) -- 承兑人开户行号
    ,discounttype varchar2(2) -- 贴现类型
    ,buybegindate date -- 赎回开放日
    ,buyrate number(24,6) -- 赎回利率
    ,payeeacctno varchar2(150) -- 收款人帐号
    ,changeday number(22) -- 调整天数
    ,billtype varchar2(16) -- 票据类型
    ,billno varchar2(30) -- 票据号码
    ,billdiscounttype varchar2(1) -- 是否跨行贴现标识（1是2否）
    ,custbillacctname varchar2(150) -- 客户结算账户户名
    ,draweracctno varchar2(32) -- 贴现客户账户
    ,billsum number(24,6) -- 贴现票据金额
    ,paveeacctbankno varchar2(32) -- 收款人行号
    ,acceptor varchar2(180) -- 承兑人名称
    ,updateorgid varchar2(40) -- 更新机构
    ,sectionno varchar2(30) -- 区间号
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
grant select on ${iol_schema}.icms_billlist_info to ${iml_schema};
grant select on ${iol_schema}.icms_billlist_info to ${icl_schema};
grant select on ${iol_schema}.icms_billlist_info to ${idl_schema};
grant select on ${iol_schema}.icms_billlist_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_billlist_info is '票据列表信息';
comment on column ${iol_schema}.icms_billlist_info.batchno is '批次号';
comment on column ${iol_schema}.icms_billlist_info.contractno is '协议编号';
comment on column ${iol_schema}.icms_billlist_info.keyno is '单笔票据唯一标示';
comment on column ${iol_schema}.icms_billlist_info.discountsum is '贴现利息';
comment on column ${iol_schema}.icms_billlist_info.discountdate is '贴现日期';
comment on column ${iol_schema}.icms_billlist_info.draweracct1name is '出票人开户行';
comment on column ${iol_schema}.icms_billlist_info.isbas is '是否可转让';
comment on column ${iol_schema}.icms_billlist_info.duedate is '到期日';
comment on column ${iol_schema}.icms_billlist_info.payee is '收款人户名';
comment on column ${iol_schema}.icms_billlist_info.purchaserpercent is '买方付息比例(贴现方式为协议付息才有效)';
comment on column ${iol_schema}.icms_billlist_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_billlist_info.draweracctname is '贴现客户账户开户行号';
comment on column ${iol_schema}.icms_billlist_info.acptdate is '出票日';
comment on column ${iol_schema}.icms_billlist_info.drawercustomer is '开票人户名';
comment on column ${iol_schema}.icms_billlist_info.manualpay is '工本费';
comment on column ${iol_schema}.icms_billlist_info.othertxbalance is '第三方付息金额';
comment on column ${iol_schema}.icms_billlist_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_billlist_info.currency is '币种';
comment on column ${iol_schema}.icms_billlist_info.guaracctno is '保证金账户';
comment on column ${iol_schema}.icms_billlist_info.paysum is '手续费';
comment on column ${iol_schema}.icms_billlist_info.czflag is '冲账标志';
comment on column ${iol_schema}.icms_billlist_info.inputdate is '录入时间';
comment on column ${iol_schema}.icms_billlist_info.buybenddate is '约定赎回日';
comment on column ${iol_schema}.icms_billlist_info.acceptorbankname is '承兑人开户行名称';
comment on column ${iol_schema}.icms_billlist_info.afeerate is '贴现利率';
comment on column ${iol_schema}.icms_billlist_info.customername is '客户名称';
comment on column ${iol_schema}.icms_billlist_info.guarterm is '保证金存期';
comment on column ${iol_schema}.icms_billlist_info.otherdraweracctno is '第三方付息账户';
comment on column ${iol_schema}.icms_billlist_info.isonline is '是否线上清算';
comment on column ${iol_schema}.icms_billlist_info.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_billlist_info.buyenddate is '赎回截止日';
comment on column ${iol_schema}.icms_billlist_info.putoutorgid is '放款机构编号';
comment on column ${iol_schema}.icms_billlist_info.draweracctbankname is '贴现客户账户开户行名';
comment on column ${iol_schema}.icms_billlist_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_billlist_info.payeeacctname is '收款人开户行';
comment on column ${iol_schema}.icms_billlist_info.guarsum is '保证金金额';
comment on column ${iol_schema}.icms_billlist_info.businesstype is '交易类型';
comment on column ${iol_schema}.icms_billlist_info.draweracctno1 is '出票人账号';
comment on column ${iol_schema}.icms_billlist_info.inputuserid is '录入人';
comment on column ${iol_schema}.icms_billlist_info.customerid is '客户号';
comment on column ${iol_schema}.icms_billlist_info.discountway is '贴现方式';
comment on column ${iol_schema}.icms_billlist_info.billclass is '票据性质';
comment on column ${iol_schema}.icms_billlist_info.acptdate2 is '承兑日';
comment on column ${iol_schema}.icms_billlist_info.interestday is '计息天数';
comment on column ${iol_schema}.icms_billlist_info.isbecustody is '是否代保管';
comment on column ${iol_schema}.icms_billlist_info.acceptorbankno is '承兑人开户行号';
comment on column ${iol_schema}.icms_billlist_info.discounttype is '贴现类型';
comment on column ${iol_schema}.icms_billlist_info.buybegindate is '赎回开放日';
comment on column ${iol_schema}.icms_billlist_info.buyrate is '赎回利率';
comment on column ${iol_schema}.icms_billlist_info.payeeacctno is '收款人帐号';
comment on column ${iol_schema}.icms_billlist_info.changeday is '调整天数';
comment on column ${iol_schema}.icms_billlist_info.billtype is '票据类型';
comment on column ${iol_schema}.icms_billlist_info.billno is '票据号码';
comment on column ${iol_schema}.icms_billlist_info.billdiscounttype is '是否跨行贴现标识（1是2否）';
comment on column ${iol_schema}.icms_billlist_info.custbillacctname is '客户结算账户户名';
comment on column ${iol_schema}.icms_billlist_info.draweracctno is '贴现客户账户';
comment on column ${iol_schema}.icms_billlist_info.billsum is '贴现票据金额';
comment on column ${iol_schema}.icms_billlist_info.paveeacctbankno is '收款人行号';
comment on column ${iol_schema}.icms_billlist_info.acceptor is '承兑人名称';
comment on column ${iol_schema}.icms_billlist_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_billlist_info.sectionno is '区间号';
comment on column ${iol_schema}.icms_billlist_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_billlist_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_billlist_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_billlist_info.etl_timestamp is 'ETL处理时间戳';
