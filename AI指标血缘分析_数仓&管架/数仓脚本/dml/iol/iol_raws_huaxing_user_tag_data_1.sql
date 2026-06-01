/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_raws_huaxing_user_tag_data_1
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
drop table ${iol_schema}.raws_huaxing_user_tag_data_1_ex purge;
alter table ${iol_schema}.raws_huaxing_user_tag_data_1 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.raws_huaxing_user_tag_data_1;

-- 2.3 insert data to ex table
create table ${iol_schema}.raws_huaxing_user_tag_data_1_ex nologging
compress
as
select * from ${iol_schema}.raws_huaxing_user_tag_data_1 where 0=1;

insert /*+ append */ into ${iol_schema}.raws_huaxing_user_tag_data_1_ex(
    user_id -- 
    ,user_tag_ykhwm30twqdayh -- 
    ,user_tag_ykhwm30twdlayh -- 
    ,user_tag_yqdawdlyh -- 
    ,user_tag_j30tnscdlyh -- 
    ,user_tag_jyyh -- 
    ,user_tag_lsfxyh -- 
    ,user_tag_glsfxyh -- 
    ,user_tag_j30tahybs -- 
    ,user_tag_j14tahybs -- 
    ,user_tag_j7tahybs -- 
    ,user_tag_csbs -- 
    ,user_tag_ahyqk -- 
    ,user_tag_zzywgpdjyh -- 
    ,user_tag_zhglywgpdjyh -- 
    ,user_tag_sygpfwyh -- 
    ,user_tag_cfygpfwyh -- 
    ,user_tag_dkygpfwyh -- 
    ,user_tag_scygpfwyh -- 
    ,user_tag_wdygpfwyh -- 
    ,user_tag_dlgpsbkhs -- 
    ,user_tag_yctcgpkh -- 
    ,user_tag_gq7tzzgnsypc -- 
    ,user_tag_gq30tzzgnsypc -- 
    ,user_tag_sjhzzphyh -- 
    ,user_tag_yhzhzzphyh -- 
    ,user_tag_zjlxrzzphyh -- 
    ,user_tag_zzddyh -- 
    ,user_tag_ssdecdcpdcs -- 
    ,user_tag_ssxxccpdcs -- 
    ,user_tag_ssbxcpdcs -- 
    ,user_tag_ssjjdcs -- 
    ,user_tag_sslccpdcs -- 
    ,user_tag_j7tlcgm -- 
    ,user_tag_lcgmddkh -- 
    ,user_tag_lcllmgxkh -- 
    ,user_tag_lcldxph -- 
    ,user_tag_lcjyrkph -- 
    ,user_tag_lcllwtjgmyh -- 
    ,user_tag_lcgmwtjyh -- 
    ,user_tag_lcgmyx -- 
    ,user_tag_lllclcpsc -- 
    ,user_tag_j7tckcpgm -- 
    ,user_tag_ckgmddkh -- 
    ,user_tag_decdcpllcs -- 
    ,user_tag_decdcpgdzr -- 
    ,user_tag_decdcprkph -- 
    ,user_tag_decdllmgxkh -- 
    ,user_tag_decdgmyx -- 
    ,user_tag_xxccpllcs -- 
    ,user_tag_xxccprkph -- 
    ,user_tag_lhycpllcs -- 
    ,user_tag_j7tjjgm -- 
    ,user_tag_jjgmddkh -- 
    ,user_tag_lljjlcpcs -- 
    ,user_tag_lljjlcpsc -- 
    ,user_tag_jjrkph -- 
    ,user_tag_jjgmyx -- 
    ,user_tag_j7tbxgm -- 
    ,user_tag_bxgmddkh -- 
    ,user_tag_llbxlcpcs -- 
    ,user_tag_llbxlcpsc -- 
    ,user_tag_bxrkph -- 
    ,user_tag_bxgmyx -- 
    ,user_tag_j7tshdxgm -- 
    ,user_tag_shdxgmddkh -- 
    ,user_tag_llshdxlcpcs -- 
    ,user_tag_llshdxlcpsc -- 
    ,user_tag_shdxrkph -- 
    ,user_tag_shdxgmyx -- 
    ,user_tag_j7tsftjdksq -- 
    ,user_tag_dkfwpgjgpcx -- 
    ,user_tag_dkrkph -- 
    ,user_tag_dkllwsqyh -- 
    ,user_tag_dkxqyllpc -- 
    ,user_tag_sfllhd -- 
    ,user_tag_sfcyhd -- 
    ,user_tag_sffxhd -- 
    ,user_tag_fgkq -- 
    ,user_tag_kcpjykh -- 
    ,user_tag_jycgcs -- 
    ,user_tag_jycgzje -- 
    ,user_tag_scjyjjts -- 
    ,user_tag_jsyjyzdje -- 
    ,user_tag_jsyjypjje -- 
    ,user_tag_rfc -- 
    ,user_tag_lszb1 -- 
    ,user_tag_lszb2 -- 
    ,user_tag_lszb3 -- 
    ,user_tag_lszb4 -- 
    ,user_tag_lszb5 -- 
    ,user_tag_lszb6 -- 
    ,user_tag_lszb7 -- 
    ,user_tag_lszb8 -- 
    ,user_tag_lszb9 -- 
    ,user_tag_lszb10 -- 
    ,user_tag_lszb11 -- 
    ,user_tag_lszb12 -- 
    ,user_tag_lszb13 -- 
    ,user_tag_lszb14 -- 
    ,user_tag_lszb15 -- 
    ,user_tag_lszb16 -- 
    ,user_tag_lszb17 -- 
    ,user_tag_lszb18 -- 
    ,user_tag_lszb19 -- 
    ,user_tag_lszb20 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    user_id -- 
    ,user_tag_ykhwm30twqdayh -- 
    ,user_tag_ykhwm30twdlayh -- 
    ,user_tag_yqdawdlyh -- 
    ,user_tag_j30tnscdlyh -- 
    ,user_tag_jyyh -- 
    ,user_tag_lsfxyh -- 
    ,user_tag_glsfxyh -- 
    ,user_tag_j30tahybs -- 
    ,user_tag_j14tahybs -- 
    ,user_tag_j7tahybs -- 
    ,user_tag_csbs -- 
    ,user_tag_ahyqk -- 
    ,user_tag_zzywgpdjyh -- 
    ,user_tag_zhglywgpdjyh -- 
    ,user_tag_sygpfwyh -- 
    ,user_tag_cfygpfwyh -- 
    ,user_tag_dkygpfwyh -- 
    ,user_tag_scygpfwyh -- 
    ,user_tag_wdygpfwyh -- 
    ,user_tag_dlgpsbkhs -- 
    ,user_tag_yctcgpkh -- 
    ,user_tag_gq7tzzgnsypc -- 
    ,user_tag_gq30tzzgnsypc -- 
    ,user_tag_sjhzzphyh -- 
    ,user_tag_yhzhzzphyh -- 
    ,user_tag_zjlxrzzphyh -- 
    ,user_tag_zzddyh -- 
    ,user_tag_ssdecdcpdcs -- 
    ,user_tag_ssxxccpdcs -- 
    ,user_tag_ssbxcpdcs -- 
    ,user_tag_ssjjdcs -- 
    ,user_tag_sslccpdcs -- 
    ,user_tag_j7tlcgm -- 
    ,user_tag_lcgmddkh -- 
    ,user_tag_lcllmgxkh -- 
    ,user_tag_lcldxph -- 
    ,user_tag_lcjyrkph -- 
    ,user_tag_lcllwtjgmyh -- 
    ,user_tag_lcgmwtjyh -- 
    ,user_tag_lcgmyx -- 
    ,user_tag_lllclcpsc -- 
    ,user_tag_j7tckcpgm -- 
    ,user_tag_ckgmddkh -- 
    ,user_tag_decdcpllcs -- 
    ,user_tag_decdcpgdzr -- 
    ,user_tag_decdcprkph -- 
    ,user_tag_decdllmgxkh -- 
    ,user_tag_decdgmyx -- 
    ,user_tag_xxccpllcs -- 
    ,user_tag_xxccprkph -- 
    ,user_tag_lhycpllcs -- 
    ,user_tag_j7tjjgm -- 
    ,user_tag_jjgmddkh -- 
    ,user_tag_lljjlcpcs -- 
    ,user_tag_lljjlcpsc -- 
    ,user_tag_jjrkph -- 
    ,user_tag_jjgmyx -- 
    ,user_tag_j7tbxgm -- 
    ,user_tag_bxgmddkh -- 
    ,user_tag_llbxlcpcs -- 
    ,user_tag_llbxlcpsc -- 
    ,user_tag_bxrkph -- 
    ,user_tag_bxgmyx -- 
    ,user_tag_j7tshdxgm -- 
    ,user_tag_shdxgmddkh -- 
    ,user_tag_llshdxlcpcs -- 
    ,user_tag_llshdxlcpsc -- 
    ,user_tag_shdxrkph -- 
    ,user_tag_shdxgmyx -- 
    ,user_tag_j7tsftjdksq -- 
    ,user_tag_dkfwpgjgpcx -- 
    ,user_tag_dkrkph -- 
    ,user_tag_dkllwsqyh -- 
    ,user_tag_dkxqyllpc -- 
    ,user_tag_sfllhd -- 
    ,user_tag_sfcyhd -- 
    ,user_tag_sffxhd -- 
    ,user_tag_fgkq -- 
    ,user_tag_kcpjykh -- 
    ,user_tag_jycgcs -- 
    ,user_tag_jycgzje -- 
    ,user_tag_scjyjjts -- 
    ,user_tag_jsyjyzdje -- 
    ,user_tag_jsyjypjje -- 
    ,user_tag_rfc -- 
    ,user_tag_lszb1 -- 
    ,user_tag_lszb2 -- 
    ,user_tag_lszb3 -- 
    ,user_tag_lszb4 -- 
    ,user_tag_lszb5 -- 
    ,user_tag_lszb6 -- 
    ,user_tag_lszb7 -- 
    ,user_tag_lszb8 -- 
    ,user_tag_lszb9 -- 
    ,user_tag_lszb10 -- 
    ,user_tag_lszb11 -- 
    ,user_tag_lszb12 -- 
    ,user_tag_lszb13 -- 
    ,user_tag_lszb14 -- 
    ,user_tag_lszb15 -- 
    ,user_tag_lszb16 -- 
    ,user_tag_lszb17 -- 
    ,user_tag_lszb18 -- 
    ,user_tag_lszb19 -- 
    ,user_tag_lszb20 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.raws_huaxing_user_tag_data_1
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.raws_huaxing_user_tag_data_1 exchange partition p_${batch_date} with table ${iol_schema}.raws_huaxing_user_tag_data_1_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.raws_huaxing_user_tag_data_1 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.raws_huaxing_user_tag_data_1_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'raws_huaxing_user_tag_data_1',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);