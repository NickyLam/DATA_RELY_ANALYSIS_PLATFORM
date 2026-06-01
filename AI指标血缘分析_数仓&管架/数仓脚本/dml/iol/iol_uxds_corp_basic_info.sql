/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_corp_basic_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_corp_basic_info_ex purge;
alter table ${iol_schema}.uxds_corp_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_corp_basic_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_corp_basic_info_ex nologging
compress
as
select * from ${iol_schema}.uxds_corp_basic_info where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_corp_basic_info_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,corp_nature -- 企业性质
    ,org_cn_introduction -- 机构简介(中文)
    ,domestic_listing_identifier -- 境内上市标识.是否发行AB股，用于区分境内上市公司和非上市公司 0：否 1：是
    ,currency_encode -- 货币编码
    ,accounting_firm_id -- 会计师事务所id
    ,law_firm_id -- 律师事务所id
    ,org_id -- 机构id
    ,org_name_cn -- 机构名称(中文)
    ,org_website -- 机构网址
    ,org_short_name_cn -- 机构简称(中文)
    ,staff_num -- 员工人数
    ,legal_representative -- 法人代表
    ,reg_address_cn -- 注册地址(中文)
    ,accounting_firm_name -- 会计师事务所名称
    ,law_firm_name -- 律师事务所名称
    ,charged_accountant -- 经办会计师
    ,charged_lawyer -- 经办律师
    ,district_encode -- 地区编码
    ,cn_regional_identifier -- 中国地区标识
    ,org_code -- 组织机构代码
    ,unified_social_credit_code -- 统一社会信用代码
    ,office_address_cn -- 办公地址(中文)
    ,postcode -- 邮政编码
    ,reg_asset -- 注册资金，单位：万元
    ,currency_name -- 货币名称
    ,established_date -- 成立日期
    ,email -- 电子信箱
    ,telephone -- 联系电话
    ,fax -- 联系传真
    ,main_operation_business -- 主营业务
    ,operating_scope -- 经营范围
    ,org_name_en -- 机构名称(英文)
    ,general_manager -- 总经理
    ,org_short_name_en -- 机构简称(英文)
    ,corp_ed -- 公司终止日期
    ,announcement_date -- 公告日期
    ,business_reg_num -- 工商登记号
    ,tax_reg_num -- 税务登记号
    ,secretary -- 董事会秘书
    ,sec_representative -- 证券事务代表
    ,org_type -- 机构类别
    ,reg_address_en -- 注册地址(英文)
    ,office_address_en -- 办公地址(英文)
    ,board_manage_analysis -- 董事会经营分析
    ,establishment_history -- 成立情况与历史沿革
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,corp_nature -- 企业性质
    ,org_cn_introduction -- 机构简介(中文)
    ,domestic_listing_identifier -- 境内上市标识.是否发行AB股，用于区分境内上市公司和非上市公司 0：否 1：是
    ,currency_encode -- 货币编码
    ,accounting_firm_id -- 会计师事务所id
    ,law_firm_id -- 律师事务所id
    ,org_id -- 机构id
    ,org_name_cn -- 机构名称(中文)
    ,org_website -- 机构网址
    ,org_short_name_cn -- 机构简称(中文)
    ,staff_num -- 员工人数
    ,legal_representative -- 法人代表
    ,reg_address_cn -- 注册地址(中文)
    ,accounting_firm_name -- 会计师事务所名称
    ,law_firm_name -- 律师事务所名称
    ,charged_accountant -- 经办会计师
    ,charged_lawyer -- 经办律师
    ,district_encode -- 地区编码
    ,cn_regional_identifier -- 中国地区标识
    ,org_code -- 组织机构代码
    ,unified_social_credit_code -- 统一社会信用代码
    ,office_address_cn -- 办公地址(中文)
    ,postcode -- 邮政编码
    ,reg_asset -- 注册资金，单位：万元
    ,currency_name -- 货币名称
    ,established_date -- 成立日期
    ,email -- 电子信箱
    ,telephone -- 联系电话
    ,fax -- 联系传真
    ,main_operation_business -- 主营业务
    ,operating_scope -- 经营范围
    ,org_name_en -- 机构名称(英文)
    ,general_manager -- 总经理
    ,org_short_name_en -- 机构简称(英文)
    ,corp_ed -- 公司终止日期
    ,announcement_date -- 公告日期
    ,business_reg_num -- 工商登记号
    ,tax_reg_num -- 税务登记号
    ,secretary -- 董事会秘书
    ,sec_representative -- 证券事务代表
    ,org_type -- 机构类别
    ,reg_address_en -- 注册地址(英文)
    ,office_address_en -- 办公地址(英文)
    ,board_manage_analysis -- 董事会经营分析
    ,establishment_history -- 成立情况与历史沿革
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_corp_basic_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_corp_basic_info exchange partition p_${batch_date} with table ${iol_schema}.uxds_corp_basic_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_corp_basic_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_corp_basic_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_corp_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);