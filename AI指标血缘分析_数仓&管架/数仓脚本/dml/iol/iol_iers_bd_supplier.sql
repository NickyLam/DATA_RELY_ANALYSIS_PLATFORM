/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_bd_supplier
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.iers_bd_supplier_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_bd_supplier
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_supplier_op purge;
drop table ${iol_schema}.iers_bd_supplier_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_supplier_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_supplier where 0=1;

create table ${iol_schema}.iers_bd_supplier_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_bd_supplier where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_supplier_cl(
            buslicensenum -- 营业执照号码
            ,code -- 供应商编码
            ,corcustomer -- 对应客户
            ,corpaddress -- 企业地址
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 自定义项3
            ,def30 -- 自定义项30
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deletestate -- 删除状态
            ,delperson -- 删除人
            ,deltime -- 删除时间
            ,dr -- 删除标志
            ,ecotypesincevfive -- 经济类型
            ,email -- e-mail地址
            ,enablestate -- 启用状态
            ,ename -- 供应商英文名称
            ,establishdate -- 成立日期
            ,fax1 -- 传真1
            ,fax2 -- 传真2
            ,iscarrier -- 承运商
            ,iscustomer -- 客户
            ,isfreecust -- 散户
            ,ismobilecoopertive -- 移动协同
            ,isoutcheck -- 外部检测机构
            ,isvat -- VAT注册码
            ,legalbody -- 法人
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 供应商名称
            ,name2 -- 供应商名称2
            ,name3 -- 供应商名称3
            ,name4 -- 供应商名称4
            ,name5 -- 供应商名称5
            ,name6 -- 供应商名称6
            ,pk_areacl -- 地区分类
            ,pk_billtypecode -- 单据类型
            ,pk_country -- 国家/地区
            ,pk_currtype -- 注册资金币种
            ,pk_financeorg -- 对应业务单元
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_oldsupplier -- 供应商旧主键
            ,pk_org -- 所属组织
            ,pk_supplier -- 供应商档案主键
            ,pk_supplier_main -- 上级供应商
            ,pk_supplier_pf -- 供应商申请单主键
            ,pk_supplierclass -- 供应商基本分类
            ,pk_suptaxes -- 供应商税类
            ,pk_timezone -- 时区
            ,registerfund -- 注册资金
            ,shortname -- 供应商简称
            ,supprop -- 供应商类型
            ,supstate -- 供应商状态
            ,taxpayerid -- 纳税人登记号
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tel3 -- 电话3
            ,trade -- 所属行业
            ,ts -- 时间戳
            ,url -- Web网址
            ,vatcode -- 对应VAT注册码
            ,zipcode -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_supplier_op(
            buslicensenum -- 营业执照号码
            ,code -- 供应商编码
            ,corcustomer -- 对应客户
            ,corpaddress -- 企业地址
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 自定义项3
            ,def30 -- 自定义项30
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deletestate -- 删除状态
            ,delperson -- 删除人
            ,deltime -- 删除时间
            ,dr -- 删除标志
            ,ecotypesincevfive -- 经济类型
            ,email -- e-mail地址
            ,enablestate -- 启用状态
            ,ename -- 供应商英文名称
            ,establishdate -- 成立日期
            ,fax1 -- 传真1
            ,fax2 -- 传真2
            ,iscarrier -- 承运商
            ,iscustomer -- 客户
            ,isfreecust -- 散户
            ,ismobilecoopertive -- 移动协同
            ,isoutcheck -- 外部检测机构
            ,isvat -- VAT注册码
            ,legalbody -- 法人
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 供应商名称
            ,name2 -- 供应商名称2
            ,name3 -- 供应商名称3
            ,name4 -- 供应商名称4
            ,name5 -- 供应商名称5
            ,name6 -- 供应商名称6
            ,pk_areacl -- 地区分类
            ,pk_billtypecode -- 单据类型
            ,pk_country -- 国家/地区
            ,pk_currtype -- 注册资金币种
            ,pk_financeorg -- 对应业务单元
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_oldsupplier -- 供应商旧主键
            ,pk_org -- 所属组织
            ,pk_supplier -- 供应商档案主键
            ,pk_supplier_main -- 上级供应商
            ,pk_supplier_pf -- 供应商申请单主键
            ,pk_supplierclass -- 供应商基本分类
            ,pk_suptaxes -- 供应商税类
            ,pk_timezone -- 时区
            ,registerfund -- 注册资金
            ,shortname -- 供应商简称
            ,supprop -- 供应商类型
            ,supstate -- 供应商状态
            ,taxpayerid -- 纳税人登记号
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tel3 -- 电话3
            ,trade -- 所属行业
            ,ts -- 时间戳
            ,url -- Web网址
            ,vatcode -- 对应VAT注册码
            ,zipcode -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.buslicensenum, o.buslicensenum) as buslicensenum -- 营业执照号码
    ,nvl(n.code, o.code) as code -- 供应商编码
    ,nvl(n.corcustomer, o.corcustomer) as corcustomer -- 对应客户
    ,nvl(n.corpaddress, o.corpaddress) as corpaddress -- 企业地址
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dataoriginflag, o.dataoriginflag) as dataoriginflag -- 分布式
    ,nvl(n.def1, o.def1) as def1 -- 自定义项1
    ,nvl(n.def10, o.def10) as def10 -- 自定义项10
    ,nvl(n.def11, o.def11) as def11 -- 自定义项11
    ,nvl(n.def12, o.def12) as def12 -- 自定义项12
    ,nvl(n.def13, o.def13) as def13 -- 自定义项13
    ,nvl(n.def14, o.def14) as def14 -- 自定义项14
    ,nvl(n.def15, o.def15) as def15 -- 自定义项15
    ,nvl(n.def16, o.def16) as def16 -- 自定义项16
    ,nvl(n.def17, o.def17) as def17 -- 自定义项17
    ,nvl(n.def18, o.def18) as def18 -- 自定义项18
    ,nvl(n.def19, o.def19) as def19 -- 自定义项19
    ,nvl(n.def2, o.def2) as def2 -- 自定义项2
    ,nvl(n.def20, o.def20) as def20 -- 自定义项20
    ,nvl(n.def21, o.def21) as def21 -- 自定义项21
    ,nvl(n.def22, o.def22) as def22 -- 自定义项22
    ,nvl(n.def23, o.def23) as def23 -- 自定义项23
    ,nvl(n.def24, o.def24) as def24 -- 自定义项24
    ,nvl(n.def25, o.def25) as def25 -- 自定义项25
    ,nvl(n.def26, o.def26) as def26 -- 自定义项26
    ,nvl(n.def27, o.def27) as def27 -- 自定义项27
    ,nvl(n.def28, o.def28) as def28 -- 自定义项28
    ,nvl(n.def29, o.def29) as def29 -- 自定义项29
    ,nvl(n.def3, o.def3) as def3 -- 自定义项3
    ,nvl(n.def30, o.def30) as def30 -- 自定义项30
    ,nvl(n.def4, o.def4) as def4 -- 自定义项4
    ,nvl(n.def5, o.def5) as def5 -- 自定义项5
    ,nvl(n.def6, o.def6) as def6 -- 自定义项6
    ,nvl(n.def7, o.def7) as def7 -- 自定义项7
    ,nvl(n.def8, o.def8) as def8 -- 自定义项8
    ,nvl(n.def9, o.def9) as def9 -- 自定义项9
    ,nvl(n.deletestate, o.deletestate) as deletestate -- 删除状态
    ,nvl(n.delperson, o.delperson) as delperson -- 删除人
    ,nvl(n.deltime, o.deltime) as deltime -- 删除时间
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.ecotypesincevfive, o.ecotypesincevfive) as ecotypesincevfive -- 经济类型
    ,nvl(n.email, o.email) as email -- e-mail地址
    ,nvl(n.enablestate, o.enablestate) as enablestate -- 启用状态
    ,nvl(n.ename, o.ename) as ename -- 供应商英文名称
    ,nvl(n.establishdate, o.establishdate) as establishdate -- 成立日期
    ,nvl(n.fax1, o.fax1) as fax1 -- 传真1
    ,nvl(n.fax2, o.fax2) as fax2 -- 传真2
    ,nvl(n.iscarrier, o.iscarrier) as iscarrier -- 承运商
    ,nvl(n.iscustomer, o.iscustomer) as iscustomer -- 客户
    ,nvl(n.isfreecust, o.isfreecust) as isfreecust -- 散户
    ,nvl(n.ismobilecoopertive, o.ismobilecoopertive) as ismobilecoopertive -- 移动协同
    ,nvl(n.isoutcheck, o.isoutcheck) as isoutcheck -- 外部检测机构
    ,nvl(n.isvat, o.isvat) as isvat -- VAT注册码
    ,nvl(n.legalbody, o.legalbody) as legalbody -- 法人
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.mnecode, o.mnecode) as mnecode -- 助记码
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.name, o.name) as name -- 供应商名称
    ,nvl(n.name2, o.name2) as name2 -- 供应商名称2
    ,nvl(n.name3, o.name3) as name3 -- 供应商名称3
    ,nvl(n.name4, o.name4) as name4 -- 供应商名称4
    ,nvl(n.name5, o.name5) as name5 -- 供应商名称5
    ,nvl(n.name6, o.name6) as name6 -- 供应商名称6
    ,nvl(n.pk_areacl, o.pk_areacl) as pk_areacl -- 地区分类
    ,nvl(n.pk_billtypecode, o.pk_billtypecode) as pk_billtypecode -- 单据类型
    ,nvl(n.pk_country, o.pk_country) as pk_country -- 国家/地区
    ,nvl(n.pk_currtype, o.pk_currtype) as pk_currtype -- 注册资金币种
    ,nvl(n.pk_financeorg, o.pk_financeorg) as pk_financeorg -- 对应业务单元
    ,nvl(n.pk_format, o.pk_format) as pk_format -- 数据格式
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_oldsupplier, o.pk_oldsupplier) as pk_oldsupplier -- 供应商旧主键
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_supplier, o.pk_supplier) as pk_supplier -- 供应商档案主键
    ,nvl(n.pk_supplier_main, o.pk_supplier_main) as pk_supplier_main -- 上级供应商
    ,nvl(n.pk_supplier_pf, o.pk_supplier_pf) as pk_supplier_pf -- 供应商申请单主键
    ,nvl(n.pk_supplierclass, o.pk_supplierclass) as pk_supplierclass -- 供应商基本分类
    ,nvl(n.pk_suptaxes, o.pk_suptaxes) as pk_suptaxes -- 供应商税类
    ,nvl(n.pk_timezone, o.pk_timezone) as pk_timezone -- 时区
    ,nvl(n.registerfund, o.registerfund) as registerfund -- 注册资金
    ,nvl(n.shortname, o.shortname) as shortname -- 供应商简称
    ,nvl(n.supprop, o.supprop) as supprop -- 供应商类型
    ,nvl(n.supstate, o.supstate) as supstate -- 供应商状态
    ,nvl(n.taxpayerid, o.taxpayerid) as taxpayerid -- 纳税人登记号
    ,nvl(n.tel1, o.tel1) as tel1 -- 电话1
    ,nvl(n.tel2, o.tel2) as tel2 -- 电话2
    ,nvl(n.tel3, o.tel3) as tel3 -- 电话3
    ,nvl(n.trade, o.trade) as trade -- 所属行业
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.url, o.url) as url -- Web网址
    ,nvl(n.vatcode, o.vatcode) as vatcode -- 对应VAT注册码
    ,nvl(n.zipcode, o.zipcode) as zipcode -- 邮政编码
    ,case when
            n.pk_supplier is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_supplier is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_supplier is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_bd_supplier_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_bd_supplier where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_supplier = n.pk_supplier
where (
        o.pk_supplier is null
    )
    or (
        n.pk_supplier is null
    )
    or (
        o.buslicensenum <> n.buslicensenum
        or o.code <> n.code
        or o.corcustomer <> n.corcustomer
        or o.corpaddress <> n.corpaddress
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dataoriginflag <> n.dataoriginflag
        or o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def21 <> n.def21
        or o.def22 <> n.def22
        or o.def23 <> n.def23
        or o.def24 <> n.def24
        or o.def25 <> n.def25
        or o.def26 <> n.def26
        or o.def27 <> n.def27
        or o.def28 <> n.def28
        or o.def29 <> n.def29
        or o.def3 <> n.def3
        or o.def30 <> n.def30
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.deletestate <> n.deletestate
        or o.delperson <> n.delperson
        or o.deltime <> n.deltime
        or o.dr <> n.dr
        or o.ecotypesincevfive <> n.ecotypesincevfive
        or o.email <> n.email
        or o.enablestate <> n.enablestate
        or o.ename <> n.ename
        or o.establishdate <> n.establishdate
        or o.fax1 <> n.fax1
        or o.fax2 <> n.fax2
        or o.iscarrier <> n.iscarrier
        or o.iscustomer <> n.iscustomer
        or o.isfreecust <> n.isfreecust
        or o.ismobilecoopertive <> n.ismobilecoopertive
        or o.isoutcheck <> n.isoutcheck
        or o.isvat <> n.isvat
        or o.legalbody <> n.legalbody
        or o.memo <> n.memo
        or o.mnecode <> n.mnecode
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.name <> n.name
        or o.name2 <> n.name2
        or o.name3 <> n.name3
        or o.name4 <> n.name4
        or o.name5 <> n.name5
        or o.name6 <> n.name6
        or o.pk_areacl <> n.pk_areacl
        or o.pk_billtypecode <> n.pk_billtypecode
        or o.pk_country <> n.pk_country
        or o.pk_currtype <> n.pk_currtype
        or o.pk_financeorg <> n.pk_financeorg
        or o.pk_format <> n.pk_format
        or o.pk_group <> n.pk_group
        or o.pk_oldsupplier <> n.pk_oldsupplier
        or o.pk_org <> n.pk_org
        or o.pk_supplier_main <> n.pk_supplier_main
        or o.pk_supplier_pf <> n.pk_supplier_pf
        or o.pk_supplierclass <> n.pk_supplierclass
        or o.pk_suptaxes <> n.pk_suptaxes
        or o.pk_timezone <> n.pk_timezone
        or o.registerfund <> n.registerfund
        or o.shortname <> n.shortname
        or o.supprop <> n.supprop
        or o.supstate <> n.supstate
        or o.taxpayerid <> n.taxpayerid
        or o.tel1 <> n.tel1
        or o.tel2 <> n.tel2
        or o.tel3 <> n.tel3
        or o.trade <> n.trade
        or o.ts <> n.ts
        or o.url <> n.url
        or o.vatcode <> n.vatcode
        or o.zipcode <> n.zipcode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_bd_supplier_cl(
            buslicensenum -- 营业执照号码
            ,code -- 供应商编码
            ,corcustomer -- 对应客户
            ,corpaddress -- 企业地址
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 自定义项3
            ,def30 -- 自定义项30
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deletestate -- 删除状态
            ,delperson -- 删除人
            ,deltime -- 删除时间
            ,dr -- 删除标志
            ,ecotypesincevfive -- 经济类型
            ,email -- e-mail地址
            ,enablestate -- 启用状态
            ,ename -- 供应商英文名称
            ,establishdate -- 成立日期
            ,fax1 -- 传真1
            ,fax2 -- 传真2
            ,iscarrier -- 承运商
            ,iscustomer -- 客户
            ,isfreecust -- 散户
            ,ismobilecoopertive -- 移动协同
            ,isoutcheck -- 外部检测机构
            ,isvat -- VAT注册码
            ,legalbody -- 法人
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 供应商名称
            ,name2 -- 供应商名称2
            ,name3 -- 供应商名称3
            ,name4 -- 供应商名称4
            ,name5 -- 供应商名称5
            ,name6 -- 供应商名称6
            ,pk_areacl -- 地区分类
            ,pk_billtypecode -- 单据类型
            ,pk_country -- 国家/地区
            ,pk_currtype -- 注册资金币种
            ,pk_financeorg -- 对应业务单元
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_oldsupplier -- 供应商旧主键
            ,pk_org -- 所属组织
            ,pk_supplier -- 供应商档案主键
            ,pk_supplier_main -- 上级供应商
            ,pk_supplier_pf -- 供应商申请单主键
            ,pk_supplierclass -- 供应商基本分类
            ,pk_suptaxes -- 供应商税类
            ,pk_timezone -- 时区
            ,registerfund -- 注册资金
            ,shortname -- 供应商简称
            ,supprop -- 供应商类型
            ,supstate -- 供应商状态
            ,taxpayerid -- 纳税人登记号
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tel3 -- 电话3
            ,trade -- 所属行业
            ,ts -- 时间戳
            ,url -- Web网址
            ,vatcode -- 对应VAT注册码
            ,zipcode -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_bd_supplier_op(
            buslicensenum -- 营业执照号码
            ,code -- 供应商编码
            ,corcustomer -- 对应客户
            ,corpaddress -- 企业地址
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dataoriginflag -- 分布式
            ,def1 -- 自定义项1
            ,def10 -- 自定义项10
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 自定义项19
            ,def2 -- 自定义项2
            ,def20 -- 自定义项20
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 自定义项3
            ,def30 -- 自定义项30
            ,def4 -- 自定义项4
            ,def5 -- 自定义项5
            ,def6 -- 自定义项6
            ,def7 -- 自定义项7
            ,def8 -- 自定义项8
            ,def9 -- 自定义项9
            ,deletestate -- 删除状态
            ,delperson -- 删除人
            ,deltime -- 删除时间
            ,dr -- 删除标志
            ,ecotypesincevfive -- 经济类型
            ,email -- e-mail地址
            ,enablestate -- 启用状态
            ,ename -- 供应商英文名称
            ,establishdate -- 成立日期
            ,fax1 -- 传真1
            ,fax2 -- 传真2
            ,iscarrier -- 承运商
            ,iscustomer -- 客户
            ,isfreecust -- 散户
            ,ismobilecoopertive -- 移动协同
            ,isoutcheck -- 外部检测机构
            ,isvat -- VAT注册码
            ,legalbody -- 法人
            ,memo -- 备注
            ,mnecode -- 助记码
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,name -- 供应商名称
            ,name2 -- 供应商名称2
            ,name3 -- 供应商名称3
            ,name4 -- 供应商名称4
            ,name5 -- 供应商名称5
            ,name6 -- 供应商名称6
            ,pk_areacl -- 地区分类
            ,pk_billtypecode -- 单据类型
            ,pk_country -- 国家/地区
            ,pk_currtype -- 注册资金币种
            ,pk_financeorg -- 对应业务单元
            ,pk_format -- 数据格式
            ,pk_group -- 所属集团
            ,pk_oldsupplier -- 供应商旧主键
            ,pk_org -- 所属组织
            ,pk_supplier -- 供应商档案主键
            ,pk_supplier_main -- 上级供应商
            ,pk_supplier_pf -- 供应商申请单主键
            ,pk_supplierclass -- 供应商基本分类
            ,pk_suptaxes -- 供应商税类
            ,pk_timezone -- 时区
            ,registerfund -- 注册资金
            ,shortname -- 供应商简称
            ,supprop -- 供应商类型
            ,supstate -- 供应商状态
            ,taxpayerid -- 纳税人登记号
            ,tel1 -- 电话1
            ,tel2 -- 电话2
            ,tel3 -- 电话3
            ,trade -- 所属行业
            ,ts -- 时间戳
            ,url -- Web网址
            ,vatcode -- 对应VAT注册码
            ,zipcode -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.buslicensenum -- 营业执照号码
    ,o.code -- 供应商编码
    ,o.corcustomer -- 对应客户
    ,o.corpaddress -- 企业地址
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dataoriginflag -- 分布式
    ,o.def1 -- 自定义项1
    ,o.def10 -- 自定义项10
    ,o.def11 -- 自定义项11
    ,o.def12 -- 自定义项12
    ,o.def13 -- 自定义项13
    ,o.def14 -- 自定义项14
    ,o.def15 -- 自定义项15
    ,o.def16 -- 自定义项16
    ,o.def17 -- 自定义项17
    ,o.def18 -- 自定义项18
    ,o.def19 -- 自定义项19
    ,o.def2 -- 自定义项2
    ,o.def20 -- 自定义项20
    ,o.def21 -- 自定义项21
    ,o.def22 -- 自定义项22
    ,o.def23 -- 自定义项23
    ,o.def24 -- 自定义项24
    ,o.def25 -- 自定义项25
    ,o.def26 -- 自定义项26
    ,o.def27 -- 自定义项27
    ,o.def28 -- 自定义项28
    ,o.def29 -- 自定义项29
    ,o.def3 -- 自定义项3
    ,o.def30 -- 自定义项30
    ,o.def4 -- 自定义项4
    ,o.def5 -- 自定义项5
    ,o.def6 -- 自定义项6
    ,o.def7 -- 自定义项7
    ,o.def8 -- 自定义项8
    ,o.def9 -- 自定义项9
    ,o.deletestate -- 删除状态
    ,o.delperson -- 删除人
    ,o.deltime -- 删除时间
    ,o.dr -- 删除标志
    ,o.ecotypesincevfive -- 经济类型
    ,o.email -- e-mail地址
    ,o.enablestate -- 启用状态
    ,o.ename -- 供应商英文名称
    ,o.establishdate -- 成立日期
    ,o.fax1 -- 传真1
    ,o.fax2 -- 传真2
    ,o.iscarrier -- 承运商
    ,o.iscustomer -- 客户
    ,o.isfreecust -- 散户
    ,o.ismobilecoopertive -- 移动协同
    ,o.isoutcheck -- 外部检测机构
    ,o.isvat -- VAT注册码
    ,o.legalbody -- 法人
    ,o.memo -- 备注
    ,o.mnecode -- 助记码
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.name -- 供应商名称
    ,o.name2 -- 供应商名称2
    ,o.name3 -- 供应商名称3
    ,o.name4 -- 供应商名称4
    ,o.name5 -- 供应商名称5
    ,o.name6 -- 供应商名称6
    ,o.pk_areacl -- 地区分类
    ,o.pk_billtypecode -- 单据类型
    ,o.pk_country -- 国家/地区
    ,o.pk_currtype -- 注册资金币种
    ,o.pk_financeorg -- 对应业务单元
    ,o.pk_format -- 数据格式
    ,o.pk_group -- 所属集团
    ,o.pk_oldsupplier -- 供应商旧主键
    ,o.pk_org -- 所属组织
    ,o.pk_supplier -- 供应商档案主键
    ,o.pk_supplier_main -- 上级供应商
    ,o.pk_supplier_pf -- 供应商申请单主键
    ,o.pk_supplierclass -- 供应商基本分类
    ,o.pk_suptaxes -- 供应商税类
    ,o.pk_timezone -- 时区
    ,o.registerfund -- 注册资金
    ,o.shortname -- 供应商简称
    ,o.supprop -- 供应商类型
    ,o.supstate -- 供应商状态
    ,o.taxpayerid -- 纳税人登记号
    ,o.tel1 -- 电话1
    ,o.tel2 -- 电话2
    ,o.tel3 -- 电话3
    ,o.trade -- 所属行业
    ,o.ts -- 时间戳
    ,o.url -- Web网址
    ,o.vatcode -- 对应VAT注册码
    ,o.zipcode -- 邮政编码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.iers_bd_supplier_bk o
    left join ${iol_schema}.iers_bd_supplier_op n
        on
            o.pk_supplier = n.pk_supplier
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_bd_supplier_cl d
        on
            o.pk_supplier = d.pk_supplier
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_bd_supplier;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_bd_supplier') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_bd_supplier drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_bd_supplier add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_bd_supplier exchange partition p_${batch_date} with table ${iol_schema}.iers_bd_supplier_cl;
alter table ${iol_schema}.iers_bd_supplier exchange partition p_20991231 with table ${iol_schema}.iers_bd_supplier_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_bd_supplier to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_bd_supplier_op purge;
drop table ${iol_schema}.iers_bd_supplier_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_bd_supplier_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_bd_supplier',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
