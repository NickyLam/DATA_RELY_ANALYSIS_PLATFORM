/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol raws_huaxing_user_tag_data_1
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.raws_huaxing_user_tag_data_1
whenever sqlerror continue none;
drop table ${iol_schema}.raws_huaxing_user_tag_data_1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.raws_huaxing_user_tag_data_1(
    user_id varchar2(4000) -- 
    ,user_tag_ykhwm30twqdayh varchar2(4000) -- 
    ,user_tag_ykhwm30twdlayh varchar2(4000) -- 
    ,user_tag_yqdawdlyh varchar2(4000) -- 
    ,user_tag_j30tnscdlyh varchar2(4000) -- 
    ,user_tag_jyyh varchar2(4000) -- 
    ,user_tag_lsfxyh varchar2(4000) -- 
    ,user_tag_glsfxyh varchar2(4000) -- 
    ,user_tag_j30tahybs varchar2(4000) -- 
    ,user_tag_j14tahybs varchar2(4000) -- 
    ,user_tag_j7tahybs varchar2(4000) -- 
    ,user_tag_csbs varchar2(4000) -- 
    ,user_tag_ahyqk varchar2(4000) -- 
    ,user_tag_zzywgpdjyh varchar2(4000) -- 
    ,user_tag_zhglywgpdjyh varchar2(4000) -- 
    ,user_tag_sygpfwyh varchar2(4000) -- 
    ,user_tag_cfygpfwyh varchar2(4000) -- 
    ,user_tag_dkygpfwyh varchar2(4000) -- 
    ,user_tag_scygpfwyh varchar2(4000) -- 
    ,user_tag_wdygpfwyh varchar2(4000) -- 
    ,user_tag_dlgpsbkhs varchar2(4000) -- 
    ,user_tag_yctcgpkh varchar2(4000) -- 
    ,user_tag_gq7tzzgnsypc varchar2(4000) -- 
    ,user_tag_gq30tzzgnsypc varchar2(4000) -- 
    ,user_tag_sjhzzphyh varchar2(4000) -- 
    ,user_tag_yhzhzzphyh varchar2(4000) -- 
    ,user_tag_zjlxrzzphyh varchar2(4000) -- 
    ,user_tag_zzddyh varchar2(4000) -- 
    ,user_tag_ssdecdcpdcs varchar2(4000) -- 
    ,user_tag_ssxxccpdcs varchar2(4000) -- 
    ,user_tag_ssbxcpdcs varchar2(4000) -- 
    ,user_tag_ssjjdcs varchar2(4000) -- 
    ,user_tag_sslccpdcs varchar2(4000) -- 
    ,user_tag_j7tlcgm varchar2(4000) -- 
    ,user_tag_lcgmddkh varchar2(4000) -- 
    ,user_tag_lcllmgxkh varchar2(4000) -- 
    ,user_tag_lcldxph varchar2(4000) -- 
    ,user_tag_lcjyrkph varchar2(4000) -- 
    ,user_tag_lcllwtjgmyh varchar2(4000) -- 
    ,user_tag_lcgmwtjyh varchar2(4000) -- 
    ,user_tag_lcgmyx varchar2(4000) -- 
    ,user_tag_lllclcpsc varchar2(4000) -- 
    ,user_tag_j7tckcpgm varchar2(4000) -- 
    ,user_tag_ckgmddkh varchar2(4000) -- 
    ,user_tag_decdcpllcs varchar2(4000) -- 
    ,user_tag_decdcpgdzr varchar2(4000) -- 
    ,user_tag_decdcprkph varchar2(4000) -- 
    ,user_tag_decdllmgxkh varchar2(4000) -- 
    ,user_tag_decdgmyx varchar2(4000) -- 
    ,user_tag_xxccpllcs varchar2(4000) -- 
    ,user_tag_xxccprkph varchar2(4000) -- 
    ,user_tag_lhycpllcs varchar2(4000) -- 
    ,user_tag_j7tjjgm varchar2(4000) -- 
    ,user_tag_jjgmddkh varchar2(4000) -- 
    ,user_tag_lljjlcpcs varchar2(4000) -- 
    ,user_tag_lljjlcpsc varchar2(4000) -- 
    ,user_tag_jjrkph varchar2(4000) -- 
    ,user_tag_jjgmyx varchar2(4000) -- 
    ,user_tag_j7tbxgm varchar2(4000) -- 
    ,user_tag_bxgmddkh varchar2(4000) -- 
    ,user_tag_llbxlcpcs varchar2(4000) -- 
    ,user_tag_llbxlcpsc varchar2(4000) -- 
    ,user_tag_bxrkph varchar2(4000) -- 
    ,user_tag_bxgmyx varchar2(4000) -- 
    ,user_tag_j7tshdxgm varchar2(4000) -- 
    ,user_tag_shdxgmddkh varchar2(4000) -- 
    ,user_tag_llshdxlcpcs varchar2(4000) -- 
    ,user_tag_llshdxlcpsc varchar2(4000) -- 
    ,user_tag_shdxrkph varchar2(4000) -- 
    ,user_tag_shdxgmyx varchar2(4000) -- 
    ,user_tag_j7tsftjdksq varchar2(4000) -- 
    ,user_tag_dkfwpgjgpcx varchar2(4000) -- 
    ,user_tag_dkrkph varchar2(4000) -- 
    ,user_tag_dkllwsqyh varchar2(4000) -- 
    ,user_tag_dkxqyllpc varchar2(4000) -- 
    ,user_tag_sfllhd varchar2(4000) -- 
    ,user_tag_sfcyhd varchar2(4000) -- 
    ,user_tag_sffxhd varchar2(4000) -- 
    ,user_tag_fgkq varchar2(4000) -- 
    ,user_tag_kcpjykh varchar2(4000) -- 
    ,user_tag_jycgcs varchar2(4000) -- 
    ,user_tag_jycgzje varchar2(4000) -- 
    ,user_tag_scjyjjts varchar2(4000) -- 
    ,user_tag_jsyjyzdje varchar2(4000) -- 
    ,user_tag_jsyjypjje varchar2(4000) -- 
    ,user_tag_rfc varchar2(4000) -- 
    ,user_tag_lszb1 varchar2(4000) -- 
    ,user_tag_lszb2 varchar2(4000) -- 
    ,user_tag_lszb3 varchar2(4000) -- 
    ,user_tag_lszb4 varchar2(4000) -- 
    ,user_tag_lszb5 varchar2(4000) -- 
    ,user_tag_lszb6 varchar2(4000) -- 
    ,user_tag_lszb7 varchar2(4000) -- 
    ,user_tag_lszb8 varchar2(4000) -- 
    ,user_tag_lszb9 varchar2(4000) -- 
    ,user_tag_lszb10 varchar2(4000) -- 
    ,user_tag_lszb11 varchar2(4000) -- 
    ,user_tag_lszb12 varchar2(4000) -- 
    ,user_tag_lszb13 varchar2(4000) -- 
    ,user_tag_lszb14 varchar2(4000) -- 
    ,user_tag_lszb15 varchar2(4000) -- 
    ,user_tag_lszb16 varchar2(4000) -- 
    ,user_tag_lszb17 varchar2(4000) -- 
    ,user_tag_lszb18 varchar2(4000) -- 
    ,user_tag_lszb19 varchar2(4000) -- 
    ,user_tag_lszb20 varchar2(4000) -- 
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
grant select on ${iol_schema}.raws_huaxing_user_tag_data_1 to ${iml_schema};
grant select on ${iol_schema}.raws_huaxing_user_tag_data_1 to ${icl_schema};
grant select on ${iol_schema}.raws_huaxing_user_tag_data_1 to ${idl_schema};
grant select on ${iol_schema}.raws_huaxing_user_tag_data_1 to ${iel_schema};

-- comment
comment on table ${iol_schema}.raws_huaxing_user_tag_data_1 is '用户标签表';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_id is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ykhwm30twqdayh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ykhwm30twdlayh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_yqdawdlyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j30tnscdlyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jyyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lsfxyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_glsfxyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j30tahybs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j14tahybs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tahybs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_csbs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ahyqk is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_zzywgpdjyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_zhglywgpdjyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_sygpfwyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_cfygpfwyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_dkygpfwyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_scygpfwyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_wdygpfwyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_dlgpsbkhs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_yctcgpkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_gq7tzzgnsypc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_gq30tzzgnsypc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_sjhzzphyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_yhzhzzphyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_zjlxrzzphyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_zzddyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ssdecdcpdcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ssxxccpdcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ssbxcpdcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ssjjdcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_sslccpdcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tlcgm is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcgmddkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcllmgxkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcldxph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcjyrkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcllwtjgmyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcgmwtjyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lcgmyx is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lllclcpsc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tckcpgm is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_ckgmddkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_decdcpllcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_decdcpgdzr is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_decdcprkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_decdllmgxkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_decdgmyx is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_xxccpllcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_xxccprkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lhycpllcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tjjgm is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jjgmddkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lljjlcpcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lljjlcpsc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jjrkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jjgmyx is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tbxgm is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_bxgmddkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_llbxlcpcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_llbxlcpsc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_bxrkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_bxgmyx is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tshdxgm is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_shdxgmddkh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_llshdxlcpcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_llshdxlcpsc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_shdxrkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_shdxgmyx is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_j7tsftjdksq is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_dkfwpgjgpcx is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_dkrkph is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_dkllwsqyh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_dkxqyllpc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_sfllhd is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_sfcyhd is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_sffxhd is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_fgkq is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_kcpjykh is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jycgcs is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jycgzje is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_scjyjjts is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jsyjyzdje is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_jsyjypjje is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_rfc is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb1 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb2 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb3 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb4 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb5 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb6 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb7 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb8 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb9 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb10 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb11 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb12 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb13 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb14 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb15 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb16 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb17 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb18 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb19 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.user_tag_lszb20 is '';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.raws_huaxing_user_tag_data_1.etl_timestamp is 'ETL处理时间戳';
