/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_raws_huaxing_user_tag_data_1
CreateDate: 20221105
FileType:   DML
Logs:
    sundexin
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.raws_huaxing_user_tag_data_1 drop partition p_${last_date};
alter table ${idl_schema}.raws_huaxing_user_tag_data_1 drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.raws_huaxing_user_tag_data_1 add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.raws_huaxing_user_tag_data_1 partition for (to_date('${batch_date}','yyyymmdd')) (
     etl_dt  -- 数据日期
    ,user_id
    ,user_tag_ykhwm30twqdayh
    ,user_tag_ykhwm30twdlayh
    ,user_tag_yqdawdlyh
    ,user_tag_j30tnscdlyh
    ,user_tag_jyyh
    ,user_tag_lsfxyh
    ,user_tag_glsfxyh
    ,user_tag_j30tahybs
    ,user_tag_j14tahybs
    ,user_tag_j7tahybs
    ,user_tag_csbs
    ,user_tag_ahyqk
    ,user_tag_zzywgpdjyh
    ,user_tag_zhglywgpdjyh
    ,user_tag_sygpfwyh
    ,user_tag_cfygpfwyh
    ,user_tag_dkygpfwyh
    ,user_tag_scygpfwyh
    ,user_tag_wdygpfwyh
    ,user_tag_dlgpsbkhs
    ,user_tag_yctcgpkh
    ,user_tag_gq7tzzgnsypc
    ,user_tag_gq30tzzgnsypc
    ,user_tag_sjhzzphyh
    ,user_tag_yhzhzzphyh
    ,user_tag_zjlxrzzphyh
    ,user_tag_zzddyh
    ,user_tag_ssdecdcpdcs
    ,user_tag_ssxxccpdcs
    ,user_tag_ssbxcpdcs
    ,user_tag_ssjjdcs
    ,user_tag_sslccpdcs
    ,user_tag_j7tlcgm
    ,user_tag_lcgmddkh
    ,user_tag_lcllmgxkh
    ,user_tag_lcldxph
    ,user_tag_lcjyrkph
    ,user_tag_lcllwtjgmyh
    ,user_tag_lcgmwtjyh
    ,user_tag_lcgmyx
    ,user_tag_lllclcpsc
    ,user_tag_j7tckcpgm
    ,user_tag_ckgmddkh
    ,user_tag_decdcpllcs
    ,user_tag_decdcpgdzr
    ,user_tag_decdcprkph
    ,user_tag_decdllmgxkh
    ,user_tag_decdgmyx
    ,user_tag_xxccpllcs
    ,user_tag_xxccprkph
    ,user_tag_lhycpllcs
    ,user_tag_j7tjjgm
    ,user_tag_jjgmddkh
    ,user_tag_lljjlcpcs
    ,user_tag_lljjlcpsc
    ,user_tag_jjrkph
    ,user_tag_jjgmyx
    ,user_tag_j7tbxgm
    ,user_tag_bxgmddkh
    ,user_tag_llbxlcpcs
    ,user_tag_llbxlcpsc
    ,user_tag_bxrkph
    ,user_tag_bxgmyx
    ,user_tag_j7tshdxgm
    ,user_tag_shdxgmddkh
    ,user_tag_llshdxlcpcs
    ,user_tag_llshdxlcpsc
    ,user_tag_shdxrkph
    ,user_tag_shdxgmyx
    ,user_tag_j7tsftjdksq
    ,user_tag_dkfwpgjgpcx
    ,user_tag_dkrkph
    ,user_tag_dkllwsqyh
    ,user_tag_dkxqyllpc
    ,user_tag_sfllhd
    ,user_tag_sfcyhd
    ,user_tag_sffxhd
    ,user_tag_fgkq
    ,user_tag_kcpjykh
    ,user_tag_jycgcs
    ,user_tag_jycgzje
    ,user_tag_scjyjjts
    ,user_tag_jsyjyzdje
    ,user_tag_jsyjypjje
    ,user_tag_rfc
    ,user_tag_lszb1
    ,user_tag_lszb2
    ,user_tag_lszb3
    ,user_tag_lszb4
    ,user_tag_lszb5
    ,user_tag_lszb6
    ,user_tag_lszb7
    ,user_tag_lszb8
    ,user_tag_lszb9
    ,user_tag_lszb10
    ,user_tag_lszb11
    ,user_tag_lszb12
    ,user_tag_lszb13
    ,user_tag_lszb14
    ,user_tag_lszb15
    ,user_tag_lszb16
    ,user_tag_lszb17
    ,user_tag_lszb18
    ,user_tag_lszb19
    ,user_tag_lszb20
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')  -- 数据日期
    ,replace(replace(t.user_id,chr(13),''),chr(10),'') as user_id
    ,replace(replace(t.user_tag_ykhwm30twqdayh,chr(13),''),chr(10),'') as user_tag_ykhwm30twqdayh
    ,replace(replace(t.user_tag_ykhwm30twdlayh,chr(13),''),chr(10),'') as user_tag_ykhwm30twdlayh
    ,replace(replace(t.user_tag_yqdawdlyh,chr(13),''),chr(10),'') as user_tag_yqdawdlyh
    ,replace(replace(t.user_tag_j30tnscdlyh,chr(13),''),chr(10),'') as user_tag_j30tnscdlyh
    ,replace(replace(t.user_tag_jyyh,chr(13),''),chr(10),'') as user_tag_jyyh
    ,replace(replace(t.user_tag_lsfxyh,chr(13),''),chr(10),'') as user_tag_lsfxyh
    ,replace(replace(t.user_tag_glsfxyh,chr(13),''),chr(10),'') as user_tag_glsfxyh
    ,replace(replace(t.user_tag_j30tahybs,chr(13),''),chr(10),'') as user_tag_j30tahybs
    ,replace(replace(t.user_tag_j14tahybs,chr(13),''),chr(10),'') as user_tag_j14tahybs
    ,replace(replace(t.user_tag_j7tahybs,chr(13),''),chr(10),'') as user_tag_j7tahybs
    ,replace(replace(t.user_tag_csbs,chr(13),''),chr(10),'') as user_tag_csbs
    ,replace(replace(t.user_tag_ahyqk,chr(13),''),chr(10),'') as user_tag_ahyqk
    ,replace(replace(t.user_tag_zzywgpdjyh,chr(13),''),chr(10),'') as user_tag_zzywgpdjyh
    ,replace(replace(t.user_tag_zhglywgpdjyh,chr(13),''),chr(10),'') as user_tag_zhglywgpdjyh
    ,replace(replace(t.user_tag_sygpfwyh,chr(13),''),chr(10),'') as user_tag_sygpfwyh
    ,replace(replace(t.user_tag_cfygpfwyh,chr(13),''),chr(10),'') as user_tag_cfygpfwyh
    ,replace(replace(t.user_tag_dkygpfwyh,chr(13),''),chr(10),'') as user_tag_dkygpfwyh
    ,replace(replace(t.user_tag_scygpfwyh,chr(13),''),chr(10),'') as user_tag_scygpfwyh
    ,replace(replace(t.user_tag_wdygpfwyh,chr(13),''),chr(10),'') as user_tag_wdygpfwyh
    ,replace(replace(t.user_tag_dlgpsbkhs,chr(13),''),chr(10),'') as user_tag_dlgpsbkhs
    ,replace(replace(t.user_tag_yctcgpkh,chr(13),''),chr(10),'') as user_tag_yctcgpkh
    ,replace(replace(t.user_tag_gq7tzzgnsypc,chr(13),''),chr(10),'') as user_tag_gq7tzzgnsypc
    ,replace(replace(t.user_tag_gq30tzzgnsypc,chr(13),''),chr(10),'') as user_tag_gq30tzzgnsypc
    ,replace(replace(t.user_tag_sjhzzphyh,chr(13),''),chr(10),'') as user_tag_sjhzzphyh
    ,replace(replace(t.user_tag_yhzhzzphyh,chr(13),''),chr(10),'') as user_tag_yhzhzzphyh
    ,replace(replace(t.user_tag_zjlxrzzphyh,chr(13),''),chr(10),'') as user_tag_zjlxrzzphyh
    ,replace(replace(t.user_tag_zzddyh,chr(13),''),chr(10),'') as user_tag_zzddyh
    ,replace(replace(t.user_tag_ssdecdcpdcs,chr(13),''),chr(10),'') as user_tag_ssdecdcpdcs
    ,replace(replace(t.user_tag_ssxxccpdcs,chr(13),''),chr(10),'') as user_tag_ssxxccpdcs
    ,replace(replace(t.user_tag_ssbxcpdcs,chr(13),''),chr(10),'') as user_tag_ssbxcpdcs
    ,replace(replace(t.user_tag_ssjjdcs,chr(13),''),chr(10),'') as user_tag_ssjjdcs
    ,replace(replace(t.user_tag_sslccpdcs,chr(13),''),chr(10),'') as user_tag_sslccpdcs
    ,replace(replace(t.user_tag_j7tlcgm,chr(13),''),chr(10),'') as user_tag_j7tlcgm
    ,replace(replace(t.user_tag_lcgmddkh,chr(13),''),chr(10),'') as user_tag_lcgmddkh
    ,replace(replace(t.user_tag_lcllmgxkh,chr(13),''),chr(10),'') as user_tag_lcllmgxkh
    ,replace(replace(t.user_tag_lcldxph,chr(13),''),chr(10),'') as user_tag_lcldxph
    ,replace(replace(t.user_tag_lcjyrkph,chr(13),''),chr(10),'') as user_tag_lcjyrkph
    ,replace(replace(t.user_tag_lcllwtjgmyh,chr(13),''),chr(10),'') as user_tag_lcllwtjgmyh
    ,replace(replace(t.user_tag_lcgmwtjyh,chr(13),''),chr(10),'') as user_tag_lcgmwtjyh
    ,replace(replace(t.user_tag_lcgmyx,chr(13),''),chr(10),'') as user_tag_lcgmyx
    ,replace(replace(t.user_tag_lllclcpsc,chr(13),''),chr(10),'') as user_tag_lllclcpsc
    ,replace(replace(t.user_tag_j7tckcpgm,chr(13),''),chr(10),'') as user_tag_j7tckcpgm
    ,replace(replace(t.user_tag_ckgmddkh,chr(13),''),chr(10),'') as user_tag_ckgmddkh
    ,replace(replace(t.user_tag_decdcpllcs,chr(13),''),chr(10),'') as user_tag_decdcpllcs
    ,replace(replace(t.user_tag_decdcpgdzr,chr(13),''),chr(10),'') as user_tag_decdcpgdzr
    ,replace(replace(t.user_tag_decdcprkph,chr(13),''),chr(10),'') as user_tag_decdcprkph
    ,replace(replace(t.user_tag_decdllmgxkh,chr(13),''),chr(10),'') as user_tag_decdllmgxkh
    ,replace(replace(t.user_tag_decdgmyx,chr(13),''),chr(10),'') as user_tag_decdgmyx
    ,replace(replace(t.user_tag_xxccpllcs,chr(13),''),chr(10),'') as user_tag_xxccpllcs
    ,replace(replace(t.user_tag_xxccprkph,chr(13),''),chr(10),'') as user_tag_xxccprkph
    ,replace(replace(t.user_tag_lhycpllcs,chr(13),''),chr(10),'') as user_tag_lhycpllcs
    ,replace(replace(t.user_tag_j7tjjgm,chr(13),''),chr(10),'') as user_tag_j7tjjgm
    ,replace(replace(t.user_tag_jjgmddkh,chr(13),''),chr(10),'') as user_tag_jjgmddkh
    ,replace(replace(t.user_tag_lljjlcpcs,chr(13),''),chr(10),'') as user_tag_lljjlcpcs
    ,replace(replace(t.user_tag_lljjlcpsc,chr(13),''),chr(10),'') as user_tag_lljjlcpsc
    ,replace(replace(t.user_tag_jjrkph,chr(13),''),chr(10),'') as user_tag_jjrkph
    ,replace(replace(t.user_tag_jjgmyx,chr(13),''),chr(10),'') as user_tag_jjgmyx
    ,replace(replace(t.user_tag_j7tbxgm,chr(13),''),chr(10),'') as user_tag_j7tbxgm
    ,replace(replace(t.user_tag_bxgmddkh,chr(13),''),chr(10),'') as user_tag_bxgmddkh
    ,replace(replace(t.user_tag_llbxlcpcs,chr(13),''),chr(10),'') as user_tag_llbxlcpcs
    ,replace(replace(t.user_tag_llbxlcpsc,chr(13),''),chr(10),'') as user_tag_llbxlcpsc
    ,replace(replace(t.user_tag_bxrkph,chr(13),''),chr(10),'') as user_tag_bxrkph
    ,replace(replace(t.user_tag_bxgmyx,chr(13),''),chr(10),'') as user_tag_bxgmyx
    ,replace(replace(t.user_tag_j7tshdxgm,chr(13),''),chr(10),'') as user_tag_j7tshdxgm
    ,replace(replace(t.user_tag_shdxgmddkh,chr(13),''),chr(10),'') as user_tag_shdxgmddkh
    ,replace(replace(t.user_tag_llshdxlcpcs,chr(13),''),chr(10),'') as user_tag_llshdxlcpcs
    ,replace(replace(t.user_tag_llshdxlcpsc,chr(13),''),chr(10),'') as user_tag_llshdxlcpsc
    ,replace(replace(t.user_tag_shdxrkph,chr(13),''),chr(10),'') as user_tag_shdxrkph
    ,replace(replace(t.user_tag_shdxgmyx,chr(13),''),chr(10),'') as user_tag_shdxgmyx
    ,replace(replace(t.user_tag_j7tsftjdksq,chr(13),''),chr(10),'') as user_tag_j7tsftjdksq
    ,replace(replace(t.user_tag_dkfwpgjgpcx,chr(13),''),chr(10),'') as user_tag_dkfwpgjgpcx
    ,replace(replace(t.user_tag_dkrkph,chr(13),''),chr(10),'') as user_tag_dkrkph
    ,replace(replace(t.user_tag_dkllwsqyh,chr(13),''),chr(10),'') as user_tag_dkllwsqyh
    ,replace(replace(t.user_tag_dkxqyllpc,chr(13),''),chr(10),'') as user_tag_dkxqyllpc
    ,replace(replace(t.user_tag_sfllhd,chr(13),''),chr(10),'') as user_tag_sfllhd
    ,replace(replace(t.user_tag_sfcyhd,chr(13),''),chr(10),'') as user_tag_sfcyhd
    ,replace(replace(t.user_tag_sffxhd,chr(13),''),chr(10),'') as user_tag_sffxhd
    ,replace(replace(t.user_tag_fgkq,chr(13),''),chr(10),'') as user_tag_fgkq
    ,replace(replace(t.user_tag_kcpjykh,chr(13),''),chr(10),'') as user_tag_kcpjykh
    ,replace(replace(t.user_tag_jycgcs,chr(13),''),chr(10),'') as user_tag_jycgcs
    ,replace(replace(t.user_tag_jycgzje,chr(13),''),chr(10),'') as user_tag_jycgzje
    ,replace(replace(t.user_tag_scjyjjts,chr(13),''),chr(10),'') as user_tag_scjyjjts
    ,replace(replace(t.user_tag_jsyjyzdje,chr(13),''),chr(10),'') as user_tag_jsyjyzdje
    ,replace(replace(t.user_tag_jsyjypjje,chr(13),''),chr(10),'') as user_tag_jsyjypjje
    ,replace(replace(t.user_tag_rfc,chr(13),''),chr(10),'') as user_tag_rfc
    ,replace(replace(t.user_tag_lszb1,chr(13),''),chr(10),'') as user_tag_lszb1
    ,replace(replace(t.user_tag_lszb2,chr(13),''),chr(10),'') as user_tag_lszb2
    ,replace(replace(t.user_tag_lszb3,chr(13),''),chr(10),'') as user_tag_lszb3
    ,replace(replace(t.user_tag_lszb4,chr(13),''),chr(10),'') as user_tag_lszb4
    ,replace(replace(t.user_tag_lszb5,chr(13),''),chr(10),'') as user_tag_lszb5
    ,replace(replace(t.user_tag_lszb6,chr(13),''),chr(10),'') as user_tag_lszb6
    ,replace(replace(t.user_tag_lszb7,chr(13),''),chr(10),'') as user_tag_lszb7
    ,replace(replace(t.user_tag_lszb8,chr(13),''),chr(10),'') as user_tag_lszb8
    ,replace(replace(t.user_tag_lszb9,chr(13),''),chr(10),'') as user_tag_lszb9
    ,replace(replace(t.user_tag_lszb10,chr(13),''),chr(10),'') as user_tag_lszb10
    ,replace(replace(t.user_tag_lszb11,chr(13),''),chr(10),'') as user_tag_lszb11
    ,replace(replace(t.user_tag_lszb12,chr(13),''),chr(10),'') as user_tag_lszb12
    ,replace(replace(t.user_tag_lszb13,chr(13),''),chr(10),'') as user_tag_lszb13
    ,replace(replace(t.user_tag_lszb14,chr(13),''),chr(10),'') as user_tag_lszb14
    ,replace(replace(t.user_tag_lszb15,chr(13),''),chr(10),'') as user_tag_lszb15
    ,replace(replace(t.user_tag_lszb16,chr(13),''),chr(10),'') as user_tag_lszb16
    ,replace(replace(t.user_tag_lszb17,chr(13),''),chr(10),'') as user_tag_lszb17
    ,replace(replace(t.user_tag_lszb18,chr(13),''),chr(10),'') as user_tag_lszb18
    ,replace(replace(t.user_tag_lszb19,chr(13),''),chr(10),'') as user_tag_lszb19
    ,replace(replace(t.user_tag_lszb20,chr(13),''),chr(10),'') as user_tag_lszb20
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
 from ${iol_schema}.raws_huaxing_user_tag_data_1 t    --用户标签表
where etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'raws_huaxing_user_tag_data_1',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);