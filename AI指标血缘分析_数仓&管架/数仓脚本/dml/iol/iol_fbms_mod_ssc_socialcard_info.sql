/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fbms_mod_ssc_socialcard_info
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
create table ${iol_schema}.fbms_mod_ssc_socialcard_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fbms_mod_ssc_socialcard_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fbms_mod_ssc_socialcard_info_op purge;
drop table ${iol_schema}.fbms_mod_ssc_socialcard_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fbms_mod_ssc_socialcard_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fbms_mod_ssc_socialcard_info where 0=1;

create table ${iol_schema}.fbms_mod_ssc_socialcard_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fbms_mod_ssc_socialcard_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fbms_mod_ssc_socialcard_info_cl(
            plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号,与客户信息表的客户号关联
            ,city_cd -- 城市代码,440500-汕头,440300-深圳,
            ,acct_flag -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
            ,is_physical_card -- 是否实体卡,0-实体卡,1-无卡账户建立,
            ,merchant -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
            ,card_type -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
            ,apply_type -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
            ,gdcard_reception_nocd -- 受理网点编码
            ,gdcard_reception_name -- 受理网点名称
            ,gdcard_claim_formcd -- 申领表编码
            ,card_version -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
            ,social_security_card_num -- 社保卡号
            ,social_security_num -- 社会保障号码
            ,post_addr -- 邮寄地址
            ,financial_cardno -- 金融卡号（社保卡号）
            ,medicare_cardno -- 医保卡号
            ,financial_acct -- 金融账户编号
            ,medicare_acct -- 医保账户编号
            ,insure_date -- 制卡日期
            ,insure_time -- 制卡时间
            ,close_date -- 销户日期
            ,close_time -- 销户时间
            ,acct_status_cd -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,medicare_acct_status_cd -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,loss_reporting_status -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,is_activation -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
            ,activation_msg -- 省卡返回启用状态信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fbms_mod_ssc_socialcard_info_op(
            plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号,与客户信息表的客户号关联
            ,city_cd -- 城市代码,440500-汕头,440300-深圳,
            ,acct_flag -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
            ,is_physical_card -- 是否实体卡,0-实体卡,1-无卡账户建立,
            ,merchant -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
            ,card_type -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
            ,apply_type -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
            ,gdcard_reception_nocd -- 受理网点编码
            ,gdcard_reception_name -- 受理网点名称
            ,gdcard_claim_formcd -- 申领表编码
            ,card_version -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
            ,social_security_card_num -- 社保卡号
            ,social_security_num -- 社会保障号码
            ,post_addr -- 邮寄地址
            ,financial_cardno -- 金融卡号（社保卡号）
            ,medicare_cardno -- 医保卡号
            ,financial_acct -- 金融账户编号
            ,medicare_acct -- 医保账户编号
            ,insure_date -- 制卡日期
            ,insure_time -- 制卡时间
            ,close_date -- 销户日期
            ,close_time -- 销户时间
            ,acct_status_cd -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,medicare_acct_status_cd -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,loss_reporting_status -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,is_activation -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
            ,activation_msg -- 省卡返回启用状态信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.plat_date, o.plat_date) as plat_date -- 平台日期
    ,nvl(n.plat_time, o.plat_time) as plat_time -- 平台时间
    ,nvl(n.plat_serial_no, o.plat_serial_no) as plat_serial_no -- 平台流水号
    ,nvl(n.cust_num, o.cust_num) as cust_num -- 客户号,与客户信息表的客户号关联
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 城市代码,440500-汕头,440300-深圳,
    ,nvl(n.acct_flag, o.acct_flag) as acct_flag -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
    ,nvl(n.is_physical_card, o.is_physical_card) as is_physical_card -- 是否实体卡,0-实体卡,1-无卡账户建立,
    ,nvl(n.merchant, o.merchant) as merchant -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
    ,nvl(n.card_type, o.card_type) as card_type -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
    ,nvl(n.apply_type, o.apply_type) as apply_type -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
    ,nvl(n.gdcard_reception_nocd, o.gdcard_reception_nocd) as gdcard_reception_nocd -- 受理网点编码
    ,nvl(n.gdcard_reception_name, o.gdcard_reception_name) as gdcard_reception_name -- 受理网点名称
    ,nvl(n.gdcard_claim_formcd, o.gdcard_claim_formcd) as gdcard_claim_formcd -- 申领表编码
    ,nvl(n.card_version, o.card_version) as card_version -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
    ,nvl(n.social_security_card_num, o.social_security_card_num) as social_security_card_num -- 社保卡号
    ,nvl(n.social_security_num, o.social_security_num) as social_security_num -- 社会保障号码
    ,nvl(n.post_addr, o.post_addr) as post_addr -- 邮寄地址
    ,nvl(n.financial_cardno, o.financial_cardno) as financial_cardno -- 金融卡号（社保卡号）
    ,nvl(n.medicare_cardno, o.medicare_cardno) as medicare_cardno -- 医保卡号
    ,nvl(n.financial_acct, o.financial_acct) as financial_acct -- 金融账户编号
    ,nvl(n.medicare_acct, o.medicare_acct) as medicare_acct -- 医保账户编号
    ,nvl(n.insure_date, o.insure_date) as insure_date -- 制卡日期
    ,nvl(n.insure_time, o.insure_time) as insure_time -- 制卡时间
    ,nvl(n.close_date, o.close_date) as close_date -- 销户日期
    ,nvl(n.close_time, o.close_time) as close_time -- 销户时间
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
    ,nvl(n.medicare_acct_status_cd, o.medicare_acct_status_cd) as medicare_acct_status_cd -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
    ,nvl(n.loss_reporting_status, o.loss_reporting_status) as loss_reporting_status -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 修改时间戳
    ,nvl(n.ext1, o.ext1) as ext1 -- 备用字段1
    ,nvl(n.ext2, o.ext2) as ext2 -- 备用字段2
    ,nvl(n.is_activation, o.is_activation) as is_activation -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
    ,nvl(n.activation_msg, o.activation_msg) as activation_msg -- 省卡返回启用状态信息
    ,case when
            n.plat_date is null
            and n.plat_serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.plat_date is null
            and n.plat_serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.plat_date is null
            and n.plat_serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fbms_mod_ssc_socialcard_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fbms_mod_ssc_socialcard_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.plat_date = n.plat_date
            and o.plat_serial_no = n.plat_serial_no
where (
        o.plat_date is null
        and o.plat_serial_no is null
    )
    or (
        n.plat_date is null
        and n.plat_serial_no is null
    )
    or (
        o.plat_time <> n.plat_time
        or o.cust_num <> n.cust_num
        or o.city_cd <> n.city_cd
        or o.acct_flag <> n.acct_flag
        or o.is_physical_card <> n.is_physical_card
        or o.merchant <> n.merchant
        or o.card_type <> n.card_type
        or o.apply_type <> n.apply_type
        or o.gdcard_reception_nocd <> n.gdcard_reception_nocd
        or o.gdcard_reception_name <> n.gdcard_reception_name
        or o.gdcard_claim_formcd <> n.gdcard_claim_formcd
        or o.card_version <> n.card_version
        or o.social_security_card_num <> n.social_security_card_num
        or o.social_security_num <> n.social_security_num
        or o.post_addr <> n.post_addr
        or o.financial_cardno <> n.financial_cardno
        or o.medicare_cardno <> n.medicare_cardno
        or o.financial_acct <> n.financial_acct
        or o.medicare_acct <> n.medicare_acct
        or o.insure_date <> n.insure_date
        or o.insure_time <> n.insure_time
        or o.close_date <> n.close_date
        or o.close_time <> n.close_time
        or o.acct_status_cd <> n.acct_status_cd
        or o.medicare_acct_status_cd <> n.medicare_acct_status_cd
        or o.loss_reporting_status <> n.loss_reporting_status
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
        or o.ext1 <> n.ext1
        or o.ext2 <> n.ext2
        or o.is_activation <> n.is_activation
        or o.activation_msg <> n.activation_msg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fbms_mod_ssc_socialcard_info_cl(
            plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号,与客户信息表的客户号关联
            ,city_cd -- 城市代码,440500-汕头,440300-深圳,
            ,acct_flag -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
            ,is_physical_card -- 是否实体卡,0-实体卡,1-无卡账户建立,
            ,merchant -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
            ,card_type -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
            ,apply_type -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
            ,gdcard_reception_nocd -- 受理网点编码
            ,gdcard_reception_name -- 受理网点名称
            ,gdcard_claim_formcd -- 申领表编码
            ,card_version -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
            ,social_security_card_num -- 社保卡号
            ,social_security_num -- 社会保障号码
            ,post_addr -- 邮寄地址
            ,financial_cardno -- 金融卡号（社保卡号）
            ,medicare_cardno -- 医保卡号
            ,financial_acct -- 金融账户编号
            ,medicare_acct -- 医保账户编号
            ,insure_date -- 制卡日期
            ,insure_time -- 制卡时间
            ,close_date -- 销户日期
            ,close_time -- 销户时间
            ,acct_status_cd -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,medicare_acct_status_cd -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,loss_reporting_status -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,is_activation -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
            ,activation_msg -- 省卡返回启用状态信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fbms_mod_ssc_socialcard_info_op(
            plat_date -- 平台日期
            ,plat_time -- 平台时间
            ,plat_serial_no -- 平台流水号
            ,cust_num -- 客户号,与客户信息表的客户号关联
            ,city_cd -- 城市代码,440500-汕头,440300-深圳,
            ,acct_flag -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
            ,is_physical_card -- 是否实体卡,0-实体卡,1-无卡账户建立,
            ,merchant -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
            ,card_type -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
            ,apply_type -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
            ,gdcard_reception_nocd -- 受理网点编码
            ,gdcard_reception_name -- 受理网点名称
            ,gdcard_claim_formcd -- 申领表编码
            ,card_version -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
            ,social_security_card_num -- 社保卡号
            ,social_security_num -- 社会保障号码
            ,post_addr -- 邮寄地址
            ,financial_cardno -- 金融卡号（社保卡号）
            ,medicare_cardno -- 医保卡号
            ,financial_acct -- 金融账户编号
            ,medicare_acct -- 医保账户编号
            ,insure_date -- 制卡日期
            ,insure_time -- 制卡时间
            ,close_date -- 销户日期
            ,close_time -- 销户时间
            ,acct_status_cd -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,medicare_acct_status_cd -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
            ,loss_reporting_status -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 修改时间戳
            ,ext1 -- 备用字段1
            ,ext2 -- 备用字段2
            ,is_activation -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
            ,activation_msg -- 省卡返回启用状态信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.plat_date -- 平台日期
    ,o.plat_time -- 平台时间
    ,o.plat_serial_no -- 平台流水号
    ,o.cust_num -- 客户号,与客户信息表的客户号关联
    ,o.city_cd -- 城市代码,440500-汕头,440300-深圳,
    ,o.acct_flag -- 账户模式,1-银行卡号+医保账户,2-银行卡号,
    ,o.is_physical_card -- 是否实体卡,0-实体卡,1-无卡账户建立,
    ,o.merchant -- 卡商编号,1-金邦达,2-楚天龙,3-东信和平,4-德生,5-毅能达,6-德诚
    ,o.card_type -- 卡类别,1-城镇职工,2-城镇居民,3-农村居民
    ,o.apply_type -- 申请类型,1-个人申请,2-网上申请,3-批量申请,5-遗失补卡,6-普通换卡,7-质保换卡
    ,o.gdcard_reception_nocd -- 受理网点编码
    ,o.gdcard_reception_name -- 受理网点名称
    ,o.gdcard_claim_formcd -- 申领表编码
    ,o.card_version -- 卡版本,1.00-一代卡,2.00-二代卡,3.00-三代卡
    ,o.social_security_card_num -- 社保卡号
    ,o.social_security_num -- 社会保障号码
    ,o.post_addr -- 邮寄地址
    ,o.financial_cardno -- 金融卡号（社保卡号）
    ,o.medicare_cardno -- 医保卡号
    ,o.financial_acct -- 金融账户编号
    ,o.medicare_acct -- 医保账户编号
    ,o.insure_date -- 制卡日期
    ,o.insure_time -- 制卡时间
    ,o.close_date -- 销户日期
    ,o.close_time -- 销户时间
    ,o.acct_status_cd -- 金融账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
    ,o.medicare_acct_status_cd -- 医保账户状态,N-新建,H-待激活,A-正常,D-不动户,S-久悬户,O-转营业外,P-逾期,C-关闭,I-预开户,R-预销户
    ,o.loss_reporting_status -- 挂失状态,0-正常,1-书面挂失,2-口头挂失
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 修改时间戳
    ,o.ext1 -- 备用字段1
    ,o.ext2 -- 备用字段2
    ,o.is_activation -- 社保卡启用状态,Y-已启用，N-未启用 默认为N-未启用,
    ,o.activation_msg -- 省卡返回启用状态信息
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
from ${iol_schema}.fbms_mod_ssc_socialcard_info_bk o
    left join ${iol_schema}.fbms_mod_ssc_socialcard_info_op n
        on
            o.plat_date = n.plat_date
            and o.plat_serial_no = n.plat_serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fbms_mod_ssc_socialcard_info_cl d
        on
            o.plat_date = d.plat_date
            and o.plat_serial_no = d.plat_serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fbms_mod_ssc_socialcard_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fbms_mod_ssc_socialcard_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fbms_mod_ssc_socialcard_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fbms_mod_ssc_socialcard_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fbms_mod_ssc_socialcard_info exchange partition p_${batch_date} with table ${iol_schema}.fbms_mod_ssc_socialcard_info_cl;
alter table ${iol_schema}.fbms_mod_ssc_socialcard_info exchange partition p_20991231 with table ${iol_schema}.fbms_mod_ssc_socialcard_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fbms_mod_ssc_socialcard_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fbms_mod_ssc_socialcard_info_op purge;
drop table ${iol_schema}.fbms_mod_ssc_socialcard_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fbms_mod_ssc_socialcard_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fbms_mod_ssc_socialcard_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
